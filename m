Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZA0Rua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZA0Rua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZA0RuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:50:04 -0500
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:39390 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756006AbZA0RuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:50:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hHi1WgjfaACZO0qLPF5/x95BuSdAVPR1kO04WESBYXu6r3EAaRm6RpZ2dCtvknm7h5YL0PDLUey9DItDFdopf6KtD8MSluosw46WI5gmlKFUQY01cJbQu6dyEoveQhR9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PCI PM: Fix suspend error paths and testing facility breakage
Date: Tue, 27 Jan 2009 09:48:35 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901262143.10434.rjw@sisk.pl>
In-Reply-To: <200901262143.10434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901270948.36109.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2009 12:43 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> If one of device drivers refuses to suspend by returning error code
> from its ->suspend() callback, the devices that have already been
> suspended are resumed by executing their drivers' ->resume()
> callbacks.  Some of these callbacks expect the device's
> configuration space to be restored if the device has been put into
> D3 before they are called.  Unfortunately, this mechanism has been
> broken by recent changes moving the restoration of config spaces
> of some devices (most importantly, USB controllers and HDA Intel)
> into the resume callbacks executed with interrupts off.  Obviously,
> these callbacks are not invoked in the suspend error path and, as a
> result, the system cannot be successfully brought back into the
> working state in case of a suspend error.  The same thing happens
> in the hibernation error path right before putting the system into
> S4.
>
> Similarly, the suspend testing facility associated with the
> /sys/power/pm_test file is broken, because it uses the very same
> mechanism that is used in the suspend and hibernation error paths.
>
> Fix the breakage by making the PCI core restore the configuration
> spaces of PCI devices that haven't been restored already before
> pci_pm_resume() is called for those devices by the PM core.

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
