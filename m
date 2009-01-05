Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZAETxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZAETxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZAETxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:53:14 -0500
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:50877 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752956AbZAETxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:53:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qHQEEkduFWzn5KFxmKM2178CVf5fsAZofd3gL7b4uWqccEiEtuFjjZurWXeL8wNuvLf+0oHOSkqPb5AagG2yLSaLOQEOTKRuxOfTHUUgMjkHS4zA2HBmB+cM0WFsWOq9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using MSI-X
Date: Mon, 5 Jan 2009 11:53:07 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200901042308.42625.rjw@sisk.pl> <20090105130439.GA6014@elte.hu>
In-Reply-To: <20090105130439.GA6014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051153.07860.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 5, 2009 5:04 am Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > pcibios_enable_device() and pcibios_disable_device() don't handle
> > IRQs for devices that have MSI enabled and it should tread the
>
> s/tread/treat
>
> > devices with MSI-X enabled in the same way.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/pci/common.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> looks good - Jesse, what do you think?

Yeah, seems obviously correct, I'll queue it up.

> Rafael, i'm curious is this in response to some regression/bug? Did some
> box or driver get confused by us enabling/disabling the GSI? Some IRQ
> flood perhaps?
>
> btw., there's a small observation:
> > +     if (!dev->msi_enabled && !dev->msix_enabled)
>
> maybe a "pci_has_gsi_irq()" wrapper would make these checks cleaner and
> would make things more robust, should there be any new IRQ delivery method
> be introduced in the future?

pci_has_msi_irq surely?  Otherwise we'll catch pretty much everything?  Or did 
you mean !pci_has_gsi_irq() here instead?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

