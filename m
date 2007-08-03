Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbXHCQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbXHCQJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762897AbXHCQJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:09:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46201 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762819AbXHCQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:09:42 -0400
Message-ID: <46B35344.3090208@garzik.org>
Date: Fri, 03 Aug 2007 12:09:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: libata git tree, mbox queue status and contents
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a quick guide to current libata work that is queued or in 
progress in some way, shape or form.

First, a guide to the branches currently in use in 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

   ALL

Everything that is exported for testing (and akpm's -mm tree). 
Currently consists of upstream-fixes + upstream + sil680-mmio branches.


   master

Vanilla upstream linux-2.6.git tree.


   mv-ahci-pata

Marvell 6121/6141 PATA support.  Needs fixing in the 'PATA controller 
command' area before it is usable, and can go upstream.


   mv-ncq

sata_mv NCQ support.  Code is complete and /should/ be working, but it 
does nothing but timeout and fallback to non-NCQ here.  Needs debugging 
before can go upstream.


   new-eh

Convert sata_qstor and sata_sx4 to new EH.  Each needs 
testing/verification before it can go upstream.


   pmask

Add proto_mask to LLDDs, alongside pio_mask, udma_mask, etc.


   sii-lbt

Enable Large Block Transfer mode on sata_sil.  Verified to work locally, 
but some bug reports on the 'net need to be tracked down before this can 
go upstream.


   sil680-mmio

BenH's MMIO patch for pata_sil680.  Some MMIO/flushing type issues were 
raised on the list, a solution was reached.  That solution must be coded 
before this can go upstream.


   upstream

Everything queued for 2.6.24.  Includes everything in upstream-fixes.


   upstream-fixes

Everything queued for 2.6.23-rc.  This tends to go upstream rapidly.




mbox queue, prefixed by author:

* Kristen: ALPM patches.  We definitely want them, as they save a ton of 
power.

* Tony Vroon: LED trigger....  hmmm

* Alan: IORDY handling -- upstream whenever Alan is happy

* Tejun: improved probe info printout.  Want to test and review in 
depth, but probably OK

* Alan: ACPI checks for 80wire cable -- upstream whenever Alan is happy

* Tejun:  Port Multiplier Support -- I still need to review in depth, 
but would like go ahead and push ata_link in

* NVIDIA: sata_nv SW NCQ: need to review WRT FIS state machine, though I 
saw some flaws in there.  OK if that is OK.

* Albert: irq_on/off.  Really need to give this some thought.  Not sure 
I like where this model is going.  Polling and twiddling irq on/off 
should be kept to a minimum, because it's sorta an admission that the 
host state machine has broken down, and we need to bandaid.  Its a 
bandaid not a root-cause solution.

* Albert: minor PIO fixes.  Need to review in depth.

* Kristen: AN: it seems that things got stuck once Al Viro voiced an 
objection?

* Ben Collins: cleanup HPA support.  Need to review and see what's 
needed today, from this patch.

