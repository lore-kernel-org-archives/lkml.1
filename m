Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZBKLfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZBKLfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZBKLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:35:06 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:49027 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZBKLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=YzZsPASl+VkxmPSTCMYQksQY6jbGEvvgpUPBd2OWcKEdXfF1RXvqbMGaHAJUx54jWm
         ds3pFkK9tGdKKhyDW/yJnyvQellokdqoh+acSwZjSitG6uiN719t8tKy6TSlTwM3o+m4
         2YHF/S1VSRNFti/Q+yaWLk/wQmAFGJeYZsgrc=
Message-ID: <4992B7EE.8020601@gmail.com>
Date: Wed, 11 Feb 2009 13:35:10 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: gregkh@suse.de
CC: Christopher Harrer <charrer@alacritech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH]  SLICOSS - use gfp_kernel where possible
Content-Type: multipart/mixed;
 boundary="------------000602030102020005000608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000602030102020005000608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Use GFP_KERNEL instead of GFP_ATOMIC where possible.

Signed_off-by: Lior Dotan <liodot@gmail.com>



--------------000602030102020005000608
Content-Type: text/plain;
 name="slicoss-gfp-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-gfp-kernel.patch"

diff -X /usr/src/linux/Documentation/dontdiff -purN a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c	2009-02-11 13:33:18.000000000 +0200
+++ b/drivers/staging/slicoss/slicoss.c	2009-02-11 13:32:53.000000000 +0200
@@ -1492,7 +1492,7 @@ static int slic_mcast_add_list(struct ad
 	}
 
 	/* Doesn't already exist.  Allocate a structure to hold it */
-	mcaddr = kmalloc(sizeof(struct mcast_address), GFP_ATOMIC);
+	mcaddr = kmalloc(sizeof(struct mcast_address), GFP_KERNEL);
 	if (mcaddr == NULL)
 		return 1;
 
@@ -2648,7 +2648,7 @@ static int slic_card_init(struct sliccar
 
 #if SLIC_DUMP_ENABLED
 	if (!card->dumpbuffer) {
-		card->dumpbuffer = kmalloc(DUMP_PAGE_SIZE, GFP_ATOMIC);
+		card->dumpbuffer = kmalloc(DUMP_PAGE_SIZE, GFP_KERNEL);
 
 		ASSERT(card->dumpbuffer);
 		if (card->dumpbuffer == NULL)
@@ -2667,7 +2667,7 @@ static int slic_card_init(struct sliccar
 	 *  Allocate COMMAND BUFFER
 	 */
 	if (!card->cmdbuffer) {
-		card->cmdbuffer = kmalloc(sizeof(struct dump_cmd), GFP_ATOMIC);
+		card->cmdbuffer = kmalloc(sizeof(struct dump_cmd), GFP_KERNEL);
 
 		ASSERT(card->cmdbuffer);
 		if (card->cmdbuffer == NULL)
@@ -2808,7 +2808,7 @@ static u32 slic_card_locate(struct adapt
 	}
 	if (!physcard) {
 		/* no structure allocated for this physical card yet */
-		physcard = kzalloc(sizeof(struct physcard), GFP_ATOMIC);
+		physcard = kzalloc(sizeof(struct physcard), GFP_KERNEL);
 		ASSERT(physcard);
 
 		DBG_MSG

--------------000602030102020005000608--
