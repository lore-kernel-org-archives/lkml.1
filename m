Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYF2KW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYF2KW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 06:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYF2KWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:22:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:31684 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYF2KWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=QbFygAROzVwa4smAYaFHFy68J6LqMn1hoOVWbiAxZklkspMDUnBMpR522Z6VXDhb6Z
         y4so+phH3M3ewu51+uM3koThSymmHvAnzIFKuRlBCc4nvbZUMIo/5bMSAGSpgKk4wmB8
         TQGEnBngvD6kRS2TM1UOLDtwAMuICDdoi54vs=
Subject: [PATCH] drivers/ide/ide-tape.c: remove double kfree
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       gadio@netvision.net.il
Content-Type: text/plain
Date: Sun, 29 Jun 2008 08:34:34 +1000
Message-Id: <1214692474.8254.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,


Coverity CID: 2336 USE_AFTER_FREE

drivers/ide/ide-tape.c ide_tape_kfree_buffer() double free's a pointer
(hint freed by an alias in first outer loop).
This patch simply removes the superfluous kfree().



Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>


diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1e1f263..86164be 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -600,7 +600,6 @@ static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 		bh = bh->b_reqnext;
 		kfree(prev_bh);
 	}
-	kfree(tape->merge_bh);
 }
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)


