Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYGNQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYGNQZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYGNQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:25:34 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:55037 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757290AbYGNQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:25:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=lbTl+F5bAezrDfRcuHQSK76iW/wbSvDRro1+MIrwBlEpPDI3nt2KVEr1LbXNGxGiU4bHBUzVhIUiYIAVKLt6kd41RvHSP0Xj69D2W4jGU5Hry2400M/YRaG56R/DNCvr;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Date: Mon, 14 Jul 2008 09:24:58 -0700
User-Agent: KMail/1.9.9
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu>
In-Reply-To: <20080713210133.GA12362@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807140924.59023.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 13, 2008 2:01 pm Ingo Molnar wrote:
> * Olaf Dabrunz <od@suse.de> wrote:
> > This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.
> >
> > The corrected versions of the Broadcom and AMD/ATI boot IRQ quirks,
> > and a patch that uses DECLARE_PCI_FIXUP_FINAL instead of *_EARLY, and
> > adds *_RESUME.
> >
> > The AMD/ATI SB700S does not need a quirk. The boot IRQs here are
> > active even when the IO-APIC lines are not masked. So even for
> > traditional IRQ handling that does not use masking, the boot IRQs need
> > to be disabled by the BIOS. If there are actual cases of BIOSes that
> > do not disable these boot IRQs in APIC mode, we could consider
> > including an SB700S patch. But I doubt this will be needed, as this
> > problem would quickly surface during testing with any general-purpose
> > OS.
> >
> > The quirk for the AMD 8131 and AMD 8132 takes identical action as an
> > existing quirk for the AMD 8131 rev. A0 and B0. The existing quirk is
> > due to an AMD erratum to fix IO-APIC mode. Our patch now deletes the
> > older quirk and adds a comment to the new one that describes the two
> > purposes of the quirk.
>
> applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.
>
> Jesse, what do you think about this topic? We are keeping it separate
> for the time being. They are not particularly pretty, but being able to
> mask/unmask irqs (without generating those legacy IRQs and creating an
> IRQ storm) is essential to -rt.

See my other reply; the branch looks good.  I agree that making sure -rt can 
work is an important feature.  My only concern is that this is touching so 
much hardware specific code that *something* is likely to break.  But as long 
as Olaf & co. can help track down any issues, I'm ok with it.

Thanks,
Jesse
