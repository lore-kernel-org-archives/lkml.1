Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab0BRPKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:10:19 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:38560 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab0BRPKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=sbeOAhpOZ3AO7GtPi6LID17bv/d4QD0SFiRxShPIfuG8cEmi0+Q7Y0S2UeU26X3xmk
         g/Qe2uOOGLZKpYqSsNi/UZxS/2bnEs9OHsZIhEKaCuE5NqCHLZ4crtOdv/Lrf1mP367R
         DhRpmlqlJbpoBJ43kgyRLfq77oThpzZKBUZRU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Documentation: remove obsolete voyager.txt file
Date: Thu, 18 Feb 2010 16:09:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201002181609.29273.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager support has been removed a year ago.

Inspired-by: Jonathan Corbet <corbet@lwn.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/voyager.txt |   95 ----------------------------------------------
 1 file changed, 95 deletions(-)

Index: b/Documentation/voyager.txt
===================================================================
--- a/Documentation/voyager.txt
+++ /dev/null
@@ -1,95 +0,0 @@
-Running Linux on the Voyager Architecture
-=========================================
-
-For full details and current project status, see
-
-http://www.hansenpartnership.com/voyager
-
-The voyager architecture was designed by NCR in the mid 80s to be a
-fully SMP capable RAS computing architecture built around intel's 486
-chip set.  The voyager came in three levels of architectural
-sophistication: 3,4 and 5 --- 1 and 2 never made it out of prototype.
-The linux patches support only the Level 5 voyager architecture (any
-machine class 3435 and above).
-
-The Voyager Architecture
-------------------------
-
-Voyager machines consist of a Baseboard with a 386 diagnostic
-processor, a Power Supply Interface (PSI) a Primary and possibly
-Secondary Microchannel bus and between 2 and 20 voyager slots.  The
-voyager slots can be populated with memory and cpu cards (up to 4GB
-memory and from 1 486 to 32 Pentium Pro processors).  Internally, the
-voyager has a dual arbitrated system bus and a configuration and test
-bus (CAT).  The voyager bus speed is 40MHz.  Therefore (since all
-voyager cards are dual ported for each system bus) the maximum
-transfer rate is 320Mb/s but only if you have your slot configuration
-tuned (only memory cards can communicate with both busses at once, CPU
-cards utilise them one at a time).
-
-Voyager SMP
------------
-
-Since voyager was the first intel based SMP system, it is slightly
-more primitive than the Intel IO-APIC approach to SMP.  Voyager allows
-arbitrary interrupt routing (including processor affinity routing) of
-all 16 PC type interrupts.  However it does this by using a modified
-5259 master/slave chip set instead of an APIC bus.  Additionally,
-voyager supports Cross Processor Interrupts (CPI) equivalent to the
-APIC IPIs.  There are two routed voyager interrupt lines provided to
-each slot.
-
-Processor Cards
----------------
-
-These come in single, dyadic and quad configurations (the quads are
-problematic--see later).  The maximum configuration is 8 quad cards
-for 32 way SMP.
-
-Quad Processors
----------------
-
-Because voyager only supplies two interrupt lines to each Processor
-card, the Quad processors have to be configured (and Bootstrapped) in
-as a pair of Master/Slave processors.
-
-In fact, most Quad cards only accept one VIC interrupt line, so they
-have one interrupt handling processor (called the VIC extended
-processor) and three non-interrupt handling processors.
-
-Current Status
---------------
-
-The System will boot on Mono, Dyad and Quad cards.  There was
-originally a Quad boot problem which has been fixed by proper gdt
-alignment in the initial boot loader.  If you still cannot get your
-voyager system to boot, email me at:
-
-<J.E.J.Bottomley@HansenPartnership.com>
-
-
-The Quad cards now support using the separate Quad CPI vectors instead
-of going through the VIC mailbox system.
-
-The Level 4 architecture (3430 and 3360 Machines) should also work
-fine.
-
-Dump Switch
------------
-
-The voyager dump switch sends out a broadcast NMI which the voyager
-code intercepts and does a task dump.
-
-Power Switch
-------------
-
-The front panel power switch is intercepted by the kernel and should
-cause a system shutdown and power off.
-
-A Note About Mixed CPU Systems
-------------------------------
-
-Linux isn't designed to handle mixed CPU systems very well.  In order
-to get everything going you *must* make sure that your lowest
-capability CPU is used for booting.  Also, mixing CPU classes
-(e.g. 486 and 586) is really not going to work very well at all.
