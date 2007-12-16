Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbXLPV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbXLPV0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbXLPV0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:26:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45490 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758213AbXLPV0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:26:33 -0500
Date: Sun, 16 Dec 2007 22:26:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       unlisted-recipients:
	no@elvis.elte.hu, To-header@elvis.elte.hu,
       on@elvis.elte.hu, "input <"@elvis.elte.hu,
       "; Rene Herman" <rene.herman@keyaccess.nl>,
       Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071216212628.GF14265@elf.ucw.cz>
References: <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com> <475F23BD.3040903@reed.com> <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com> <20071212161245.3f388229@the-village.bc.nu> <20071214143328.GB10130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214143328.GB10130@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-14 15:33:28, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > There is another reason we can't just do a dumb changeover - two 
> > actually
> > 
> > #1: Some drivers are using inb_p/outb_p in PCI cases which are going 
> > #to cause PCI posting changes. Most are probably just wrong in the 
> > #first place but they need hand checking
> 
> hm, any intelligent way to force PCI posting? I guess not.
> 
> here's a list of candidate drivers (match the out*_p() pattern and do 
> pci)
> 
> ./char/epca.c 
> ./char/sonypi.c
> ./scsi/megaraid.c
> ./ide/pci/serverworks.c
> ./ide/pci/cmd640.c
> ./input/mouse/pc110pad.c

/*
 * We try to avoid enabling the hardware if it's not
 * there, but we don't know how to test. But we do know
 * that the PC110 is not a PCI system. So if we find any
 * PCI devices in the machine, we don't have a PC110.
 */

...so pc110 _may_ be okay.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
