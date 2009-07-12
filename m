Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZGLWrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZGLWrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZGLWqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:32 -0400
Received: from kroah.org ([198.145.64.141]:33496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZGLWqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/9] sparc: remove driver-core BUS_ID_SIZE
Date: Sun, 12 Jul 2009 15:46:00 -0700
Message-Id: <1247438766-17266-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

The name size limit is gone from the driver-core, the BUS_ID_SIZE
value will be removed.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/vio.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 753d128..c28c714 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -224,7 +224,12 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	if (!strcmp(type, "domain-services-port"))
 		bus_id_name = "ds";
 
-	if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
+	/*
+	 * 20 char is the old driver-core name size limit, which is no more.
+	 * This check can probably be removed after review and possible
+	 * adaption of the vio users name length handling.
+	 */
+	if (strlen(bus_id_name) >= 20 - 4) {
 		printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
 		       bus_id_name);
 		return NULL;
-- 
1.6.3.2

