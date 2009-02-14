Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZBNVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZBNVOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBNVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:13:32 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:34276 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZBNVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:13:30 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 06/43] drivers/net/lance.c: fix sparse warnings: fix signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:13:24 +0100
Message-ID: <20090214211257.23489.76477.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Besides from fixing the signedness issue remove some
whitespace to obey to the 80 character limit.

Fix this sparse warnings:
  drivers/net/lance.c:399:19: warning: incorrect type in assignment (different signedness)
  drivers/net/lance.c:654:29: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/lance.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/lance.c b/drivers/net/lance.c
index d7afb93..d83d401 100644
--- a/drivers/net/lance.c
+++ b/drivers/net/lance.c
@@ -391,7 +391,8 @@ MODULE_LICENSE("GPL");
    */
 static int __init do_lance_probe(struct net_device *dev)
 {
-	int *port, result;
+	unsigned int *port;
+	int result;
 
 	if (high_memory <= phys_to_virt(16*1024*1024))
 		lance_need_isa_bounce_buffers = 0;
@@ -456,13 +457,13 @@ out:
 static int __init lance_probe1(struct net_device *dev, int ioaddr, int irq, int options)
 {
 	struct lance_private *lp;
-	long dma_channels;			/* Mark spuriously-busy DMA channels */
+	unsigned long dma_channels;	/* Mark spuriously-busy DMA channels */
 	int i, reset_val, lance_version;
 	const char *chipname;
 	/* Flags for specific chips or boards. */
-	unsigned char hpJ2405A = 0;		/* HP ISA adaptor */
-	int hp_builtin = 0;			/* HP on-board ethernet. */
-	static int did_version;			/* Already printed version info. */
+	unsigned char hpJ2405A = 0;	/* HP ISA adaptor */
+	int hp_builtin = 0;		/* HP on-board ethernet. */
+	static int did_version;		/* Already printed version info. */
 	unsigned long flags;
 	int err = -ENOMEM;
 	void __iomem *bios;

