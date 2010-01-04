Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221Ab0ADXsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0ADXsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093Ab0ADXsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:48:11 -0500
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:45058 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754195Ab0ADXsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:48:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=m6RDlt6WuNbu7RGqCg7+SdgUFReaiLb+0DpkpREouda9SImaJlKdWRLiInP1cD15hOzjknrRfYJ1R4IRPXo5Gz9N1EEDTEo8QFEmmMuWaWBm4eInuqrc/Sz4dHYRAoxX;
Date: Mon, 4 Jan 2010 15:48:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Message-ID: <20100104154807.295bee59@jbarnes-piketon>
In-Reply-To: <200912311215.54412.rjw@sisk.pl>
References: <200912311215.54412.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 12:15:54 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> It turns out that some PCI devices require extra delays when changing
> power state from D3 to D0 (and the other way around).  Although this
> is against the PCI specification, we can handle it quite easily by
> allowing drivers to define arbitrary D3 delays for devices known to
> require extra time for switching power states.
> 
> Introduce additional field d3_delay in struct pci_dev and use it to
> store the value of the device's D0->D3 delay, in miliseconds.  Make
> the PCI PM core code use the per-device d3_delay unless
> pci_pm_d3_delay is greater (in which case the latter is used).
> [This also allows the driver to specify d3_delay shorter than the
>  10 ms required by the PCI standard if the device is known to be able
>  to handle that.]
> 
> Make the sky2 driver set d3_delay to 150 for devices handled by it.
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14730 which is a
> listed regression from 2.6.30.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
