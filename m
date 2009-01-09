Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbZAIX0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbZAIX0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZAIXZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:25:57 -0500
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:56628 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760666AbZAIXZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:25:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OpH8tUiyOG3k9csue+fEYG7NIaDQ5hx5+sh9YbIDc++0L8jGFMGyfl4XatGWREQGlrEHDhISnBalgldZ7XLBAgS7VgNC1DJGf+5nkUeG5+gHA/b72jv0juHyvKYwGsdB;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] PCI PCIe portdrv: Do not enable port device before setting up interrupts
Date: Fri, 9 Jan 2009 15:25:52 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042354.56539.rjw@sisk.pl>
In-Reply-To: <200901042354.56539.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091525.52813.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 2:54 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The PCI Express port driver calls pci_enable_device() before setting
> up interrupts, which is wrong, because if there is an interrupt pin
> configured for the port, pci_enable_device() will likely set up an
> interrupt link for it.  However, this shouldn't be done if either
> MSI or MSI-X interrupt mode is chosen for the port.
>
> The solution is to call pci_enable_device() after setting up
> interrupts, because in that case the interrupt link won't be set up
> if MSI or MSI-X are enabled.

Hm, wonder how this bug stuck around for so long...  Good catch.

-- 
Jesse Barnes, Intel Open Source Technology Center
