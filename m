Return-Path: <linux-kernel-owner+w=401wt.eu-S1946167AbXBPU4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946167AbXBPU4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946192AbXBPU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:56:54 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41782 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946167AbXBPU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:56:53 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 16 Feb 2007 15:55:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: removing all "R/W" content from all semaphore.h files?
Message-ID: <Pine.LNX.4.64.0702161544540.20402@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(can anyone comment on whether i'm thinking about this clearly?)

  as i read it, there is no need for *any* of the semaphore.h files to
include "<linux/rwsem.h>" anymore, since R/W sems now have their own
header file <linux/rwsem.h>.  so i recently submitted a patch to
delete all those inclusions from all semaphore.h files.  IMHO, that's
a fairly safe and reasonable change -- anyone who specifically wants a
R/W semaphore should be including the appropriate header file for it
and not be picking up that definition thru semaphore.h.

  however, some of those semaphore.h files also include the macro
definition:

  #define RW_LOCK_BIAS             0x01000000

that *also* strikes me as inappropriate content for generic
semaphore.h files.  in fact, there's a fascinating variety of header
files that define that macro identically:

$ grep -rl "#define RW_LOCK_BIAS" *
include/asm-frv/semaphore.h
include/asm-arm26/locks.h
include/asm-m68knommu/semaphore.h
include/asm-i386/rwlock.h
include/asm-sh/spinlock_types.h
include/asm-arm/locks.h
include/asm-m32r/spinlock_types.h
include/asm-m68k/semaphore.h
include/asm-h8300/semaphore.h
include/asm-x86_64/rwlock.h
include/asm-cris/arch-v32/spinlock.h
include/asm-cris/semaphore.h

  so, where is the proper place for that macro definition?
semaphore.h?  locks.h?  rwlock.h?  spinlock.h?  spinlock-types.h?
the fact that that macro is defined in such differing locations
*can't* be a good thing.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
