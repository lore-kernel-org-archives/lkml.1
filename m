Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbXHZMA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbXHZMA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 08:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXHZMAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 08:00:50 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:47823 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbXHZMAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 08:00:48 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Sun, 26 Aug 2007 13:00:44 +0100
User-Agent: KMail/1.9.7
Cc: "Dermot Bradley" <dermot.bradley@sla-mobile.com>,
       linux-kernel@vger.kernel.org
References: <94439DDF32D7464A916B5068EFF76B3B0225E6AD@bart.tisolutions.biz> <20070824202002.4d11525c@the-village.bc.nu>
In-Reply-To: <20070824202002.4d11525c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708261300.45073.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 20:20:02 Alan Cox wrote:
> On Fri, 24 Aug 2007 14:39:10 +0100
>
> "Dermot Bradley" <dermot.bradley@sla-mobile.com> wrote:
> > I've just built a new machine using a ASUS M2A-VM boardboard (ATI SB600
> > chipset), AMD X2 3800+ processor, and 2 Western Digital 2.5" 80Gb drives
> > running in RAID-1 using MD. I've had these problems with both 2.6.22.1
> > and now 2.6.22.5 kernels.
> >
> > I'm getting the following errors on occasion:
> >
> > Aug 24 13:19:22 playpbx kernel: APIC error on CPU0: 00(40)
> > Aug 24 13:19:33 playpbx kernel: APIC error on CPU0: 40(40)
>
> This is not good.

FWIW, I've got the HDMI version of this board and I have exactly the same 
problem (even with the newest BIOS) if nmi_watchdog is not set to zero. Try 
booting with nmi_watchdog=0 (default on x86-64, I think) and see if these go 
away.

I guess the APIC has some difficulties handling NMIs.

> > Aug 24 13:55:31 playpbx kernel: ata3.00: exception Emask 0x42 SAct
> > 0x7fc77 SErr0x800 action 0x6 frozen
> > Aug 24 13:55:31 playpbx kernel: ata3.00: (spurious completions during
> > NCQ issue=0x0 SAct=0x7fc77 FIS=004040a1:00000008)
>
> Probably not connected - your drive seems to be talking rubbish
>
> Neither are good, the latter is probably a drive firmware problem and the
> kernel will give up using NCQ with it if it keeps doing that, which
> should be just fine.

I get the feeling this problem is independent of the APIC errors, and I don't 
see it here. I'm using Hitachi Deskstars on the on-board controller in AHCI 
mode, and everything works fine.

As Alan said, it's very possibly just the drive not properly supporting NCQ.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

