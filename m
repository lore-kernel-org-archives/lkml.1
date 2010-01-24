Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862Ab0AXQEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0AXQEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827Ab0AXQEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:04:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:4733 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0AXQEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uBQJuL6Z5NSsLmUiZO0KPbVGo1u3eMdmwCkHr3meb0SbGe/ghrBmfL9ugouiwJD0gg
         KnGUWcqn8sAkcxSz1vMZm0yBdyx39aGqNg6l8yR83ZF9f7xrQYzOB2dYi93zhNibhBXq
         DzLUulSTde9VZPVBCJX6DqG14aupObaR0Gr4Q=
From: Thiago Farina <tfransosi@gmail.com>
To: tfransosi@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Stefani Seibold <stefani@seibold.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] kernel/kfifo.c: fix "interger as NULL pointer" warning.
Date: Sun, 24 Jan 2010 11:03:48 -0500
Message-Id: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.383.g5a9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 kernel/kfifo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 32c5c15..6fe4a56 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -80,7 +80,7 @@ int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 
 	buffer = kmalloc(size, gfp_mask);
 	if (!buffer) {
-		_kfifo_init(fifo, 0, 0);
+		_kfifo_init(fifo, NULL, 0);
 		return -ENOMEM;
 	}
 
-- 
1.6.6.1.383.g5a9f

