Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYEPU7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYEPU7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYEPU64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:58:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbYEPU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:58:55 -0400
Date: Fri, 16 May 2008 21:58:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] missed kmalloc() in pcap_user.c
Message-ID: <20080516205840.GV13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index e980935..5f90358 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -50,7 +50,7 @@ static int pcap_open(void *data)
 			return -EIO;
 		}
 
-		pri->compiled = kmalloc(sizeof(struct bpf_program),
+		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
 			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
