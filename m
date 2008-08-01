Return-Path: <linux-kernel-owner+w=401wt.eu-S1761765AbYHAWpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761765AbYHAWpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760763AbYHAWmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:42:04 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52154 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753AbYHAWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:42:01 -0400
Date: Fri, 1 Aug 2008 18:41:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH 5/14] missed kmalloc() in pcap_user.c
Message-ID: <20080801224127.GA13731@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 058ad32dc7765cde3717d3aaf5415724e5738128 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/drivers/pcap_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.5.1
