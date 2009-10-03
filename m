Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZJCNBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZJCNBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZJCNBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:01:39 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:59444 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJCNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:01:38 -0400
Date: Sat, 3 Oct 2009 08:01:39 -0500
From: David Fries <david@fries.net>
To: d.stussy@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
Message-ID: <20091003130139.GT21612@spacedout.fries.net>
References: <20091003025415.GA28295@spacedout.fries.net> <328926.65135.qm@web84205.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <328926.65135.qm@web84205.mail.re3.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 03 Oct 2009 08:01:41 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 10:30:56PM -0700, - wrote:
> Thank you for finding the problem.  The kernel is way too complex
> for someone who's not familiar with it (like me) to track these
> things down.

If you do a reverse apply on the patch, does it work for you?  The
below is already reversed, so apply it normally, or just open the file
with an editor and comment out those lines.

>From 6029336426a2b43e4bc6f4a84be8789a047d139e Mon Sep 17 00:00:00 2001
From: Joao Ramos <joao.ramos@inov.pt>
Date: Sun, 17 May 2009 17:22:54 +0200
Subject: [PATCH] ide: try to use PIO Mode 0 during probe if possible

Initially set PIO Mode 0 for all host drivers that have a 'set_pio_mode'
method before the IDE core figures out the most suited PIO mode for the
attached device.

Signed-off-by: Joao Ramos <joao.ramos@inov.pt>
Cc: Sergei Shtylyov <sshtylyov@ru.montavista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 7f264ed..b609a58 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1032,15 +1032,6 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
 	}
-
-	ide_port_for_each_dev(i, drive, hwif) {
-		/*
-		 * default to PIO Mode 0 before we figure out
-		 * the most suited mode for the attached device
-		 */
-		if (port_ops && port_ops->set_pio_mode)
-			port_ops->set_pio_mode(drive, 0);
-	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
-- 
1.5.6.5


-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
