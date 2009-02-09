Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZBIUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZBIUAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZBIT7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:59:41 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51118 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbZBIT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wAYteBBD0P0p2S1Md2M1PUyz5e2MmQa0wRSuvIifQQ+xbUIx4thcdrVftK0zlJTBu4
         TlWSciAC22wc1wp/S6I+uLPTgqePe6FMh2FzorjP8g+jM7T8y6rGvjirs5vQNxK5+W1x
         aHQCLZr6/q5nVBz/4XBwU287NXRt7QKYPRyaU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:00:49 +0100
Message-Id: <20090209200049.7985.36481.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] ide: make ide_special_rq() BUG() on unknown requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: make ide_special_rq() BUG() on unknown requests

If unknown request reaches this function something is _seriously_ wrong.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -353,9 +353,7 @@ static ide_startstop_t ide_special_rq(id
 	case REQ_DRIVE_RESET:
 		return ide_do_reset(drive);
 	default:
-		blk_dump_rq_flags(rq, "ide_special_rq - bad request");
-		ide_end_request(drive, 0, 0);
-		return ide_stopped;
+		BUG();
 	}
 }
 
