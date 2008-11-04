Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYKDQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYKDQ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYKDQ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:28:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:41760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYKDQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=UDWE5rxSzCkcEafQgI9UjoJ+1AcLJOg+aTSWZSg1u06Gw9ZTrwX4bkWgYs77eB5IaQ
         8FMwsCwA4YpzuXTOTto4+2OwADepbF9YG4xv3DQkn4GidkQvZ2uU+/gplugK6wytXXtf
         q/aYSRr61RSOByI+wc3OP5ynMIvi/5IpYB7jM=
Message-ID: <491077E3.4010702@gmail.com>
Date: Tue, 04 Nov 2008 18:27:15 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: [STAGING] slicoss - use kzalloc
Content-Type: multipart/mixed;
 boundary="------------000701020108000902070909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000701020108000902070909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses kzalloc() where applicable.

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------000701020108000902070909
Content-Type: text/plain;
 name="slicoss-kzalloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-kzalloc.patch"

--- b/drivers/staging/slicoss/slicoss.c	2008-11-04 11:53:12.878116772 +0200
+++ a/drivers/staging/slicoss/slicoss.c	2008-11-04 12:08:40.800644774 +0200
@@ -2673,7 +2673,7 @@ static int slic_card_init(struct sliccar
 
 #if SLIC_DUMP_ENABLED
 	if (!card->dumpbuffer) {
-		card->dumpbuffer = kmalloc(DUMP_PAGE_SIZE, GFP_ATOMIC);
+		card->dumpbuffer = kzalloc(DUMP_PAGE_SIZE, GFP_ATOMIC);
 
 		ASSERT(card->dumpbuffer);
 		if (card->dumpbuffer == NULL)
@@ -2683,7 +2683,6 @@ static int slic_card_init(struct sliccar
 	 *  Smear the shared memory structure and then obtain
 	 *  the PHYSICAL address of this structure
 	 */
-	memset(card->dumpbuffer, 0, DUMP_PAGE_SIZE);
 	card->dumpbuffer_phys = virt_to_bus(card->dumpbuffer);
 	card->dumpbuffer_physh = SLIC_GET_ADDR_HIGH(card->dumpbuffer_phys);
 	card->dumpbuffer_physl = SLIC_GET_ADDR_LOW(card->dumpbuffer_phys);
@@ -2692,7 +2691,7 @@ static int slic_card_init(struct sliccar
 	 *  Allocate COMMAND BUFFER
 	 */
 	if (!card->cmdbuffer) {
-		card->cmdbuffer = kmalloc(sizeof(struct dump_cmd), GFP_ATOMIC);
+		card->cmdbuffer = kzalloc(sizeof(struct dump_cmd), GFP_ATOMIC);
 
 		ASSERT(card->cmdbuffer);
 		if (card->cmdbuffer == NULL)
@@ -2702,7 +2701,6 @@ static int slic_card_init(struct sliccar
 	 *  Smear the shared memory structure and then obtain
 	 *  the PHYSICAL address of this structure
 	 */
-	memset(card->cmdbuffer, 0, sizeof(struct dump_cmd));
 	card->cmdbuffer_phys = virt_to_bus(card->cmdbuffer);
 	card->cmdbuffer_physh = SLIC_GET_ADDR_HIGH(card->cmdbuffer_phys);
 	card->cmdbuffer_physl = SLIC_GET_ADDR_LOW(card->cmdbuffer_phys);
@@ -2833,9 +2831,8 @@ static u32 slic_card_locate(struct adapt
 	}
 	if (!physcard) {
 		/* no structure allocated for this physical card yet */
-		physcard = kmalloc(sizeof(struct physcard *), GFP_ATOMIC);
+		physcard = kzalloc(sizeof(struct physcard *), GFP_ATOMIC);
 		ASSERT(physcard);
-		memset(physcard, 0, sizeof(struct physcard *));
 
 		DBG_MSG
 		    ("\n%s Allocate a PHYSICALcard:\n    PHYSICAL_Card[%p]\n\

--------------000701020108000902070909--
