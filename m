Return-Path: <linux-kernel-owner+w=401wt.eu-S1764008AbYD0Uvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764008AbYD0Uvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYD0Uva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:51:30 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60843 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYD0Uv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:51:29 -0400
Subject: Breakage caused by unreviewed patch in x86 tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 16:51:25 -0400
Message-Id: <1209329485.3801.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:

commit 6371b495991debfd1417b17c2bc4f7d7bae05739
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 30 13:33:40 2008 +0100

    x86: change ioremap() to default to uncached

As far as I can tell went blindly into the x86 tree without being shared
on any mailing list at all.  How can something that completely alters
the semantics of ioremap on x86 platforms go in without any review.

I'm pissed off because it broke a class of voyager machines: those which
rely on the quad interrupt controller (QIC).  The precis of why they
broke is because the QIC does IPIs (or CPIs in its terminology) via
cache line interference: you interrupt a processor by moving a
designated memory area to write exclusive in the cache (by simply
writing to the line) and the CPU acks the interrupt by moving it back to
read shared (by reading from it).  That area, is, of course, mapped by
ioremap, so reversing the ioremap semantics and adding the uncached bit
completely breaks the QIC.  I might add that the intel SAPIC functions
in roughly the same manner, so this might break more than just voyager.

This patch was originally proposed my Matthew Wilcox in March 2006:

http://lkml.org/lkml/2006/3/30/251

And after a reasonable discussion, it was decided that there was too
much risk of breakage to take it.  How come you two decided that an
identical patch with different authorship could go in to your tree
without discussion this time?

James


