Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZBPVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZBPVBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZBPVB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:01:28 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36201 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZBPVB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:01:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18841.54304.460011.351580@harpo.it.uu.se>
Date: Mon, 16 Feb 2009 22:01:20 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andreas Mohr <andi@lisas.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [BUG] 2.6.29-rc2-git1 to -rc5: libata lockup on boot, LED solid,
	100% CPU
In-Reply-To: <20090216200643.GA2393@rhlx01.hs-esslingen.de>
References: <20090216200643.GA2393@rhlx01.hs-esslingen.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr writes:
 > Hello all,
 > 
 > My Inspiron 8000 ICH2 (i810) P3/700 UP has a hard time booting 2.6.29 things:
 > 
 > [loaded init, shell stuff]
 > ...
 > ata1.00: configured for UDMA/100
 > ata1.01: configured for UDMA/33
 > ata1: EH complete
 > ...
 > Uniform CD-ROM driver Revision: 3.20
 > [LAST LINE, FULL STOP]
 > ---> hangs with IDE LED solidly on! <---
 > 
 > NOTE: kernel did NOT hang when accidentally running rc2-git1 w/o any modules loaded!
 > (IOW, probably a module-related hang)
 > disabling sr_mod.ko will make a boot proceed a tiny bit, then hang anyway
 > 
 > Could be mutex deadlock (CPU hot, 100%?)
 > no log errors whatsoever
 > latest known working: .28-rc6 (admittedly somewhat old; DOES work currently)
 > earliest known buggy: -rc2-git1, -rc4 also, -rc5 also
 > no SysRq available (notebook keys: no workey, /proc/sysrq obviously
 > not available either)
 > 
 > Should I test 2.6.28.5? Every build will take two hours though...
 > Not ATA-SFF 32bit bug problem, right? (already committed?)
 > http://marc.info/?l=linux-kernel&m=123254501314058&w=2

To me it looks like the 32-bit PIO bug. The patch you cited above was
just the first to identify the issue. This is still unfixed in 29-rc5.
Please test Sergei's latest proposed patch posted yesterday to linux-ide.
