Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZKBLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZKBLXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZKBLXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:23:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbZKBLXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:23:23 -0500
Date: Mon, 2 Nov 2009 12:23:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [3/3,ARM] msm: add minimal board file for HTC Dream device
Message-ID: <20091102112321.GC26989@elf.ucw.cz>
References: <20091101221345.GA16926@elf.ucw.cz>
 <a55d774e0911011501x6abdb6a2p117f7038a4fa80cf@mail.gmail.com>
 <20091101231950.GF20740@elf.ucw.cz>
 <a55d774e0911011533xf9b1285k7dc92745f2fb4edf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0911011533xf9b1285k7dc92745f2fb4edf@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-01 15:33:39, Brian Swetland wrote:
> On Sun, Nov 1, 2009 at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >>
> >> Pretty sure it's something later than .29
> >
> > I guess I should try 2.6.31.
> >
> >> Does enabling DEBUG_LL help?  If something's dying before the serial
> >> port is registered, you might never see any console chatter.
> >
> > DEBUG_LL does not help. Is that early_printk() equivalent?
> > With DEBUG_ICEDC I don't even get "uncompressing linux" message.
> 
> ICEDCC will try to send messages to JTAG DCC.
> 
> Sticking a call to printascii(printk_buf) after the vscnprintf() in
> vprintk() in kernel/printk.c is sometimes useful alongside DEBUG_LL
> (so that printks will go to the serial port immediately).

Thanks, that did the trick. I'm now at:

Uncompressing
Linux...................................................................
 done, booting the kernel.
<5>Linux version 2.6.32-rc5-00486-g5b11a58-dirty (pavel@amd) (gcc
version 4.3.2 (Debi9
CPU: ARMv6-compatible processor [4117b362] revision 2 (ARMv6TEJ),
cr=00c5387f
CPU: VIPT aliasing data cache, VIPT aliasing instruction cache
Machine: HTC Dream
<4>Ignoring unrecognised tag 0x4d534d70
<4>Ignoring unrecognised tag 0x57494649
<4>Ignoring unrecognised tag 0x89768976
Memory policy: ECC disabled, Data cache writeback
<3>INITRD: 0x11000000+0x00024aa8 extends beyond physical memory -
disabling initrd
<7>On node 0 totalpages: 0
<1>bootmem alloc of 32768 bytes failed!
<0>Kernel panic - not syncing: Out of memory

...and I managed to fix that by introducing dream_fixup(). Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
