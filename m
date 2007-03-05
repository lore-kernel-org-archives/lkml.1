Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXCEU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXCEU6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbXCEU6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:17 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46864 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbXCEU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:10 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 06/11] uml: fix a memory leak in the multicast driver
Date: Mon, 05 Mar 2007 21:49:04 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204904.9072.74534.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L00ZJ008281

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Memory allocated by mcast_user_init must be freed in the matching mcast_remove.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/drivers/mcast_user.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/mcast_user.c b/arch/um/drivers/mcast_user.c
index 8138f5e..b827e82 100644
--- a/arch/um/drivers/mcast_user.c
+++ b/arch/um/drivers/mcast_user.c
@@ -50,6 +50,14 @@ static void mcast_user_init(void *data, void *dev)
 	pri->dev = dev;
 }
 
+static void mcast_remove(void *data)
+{
+	struct mcast_data *pri = data;
+
+	kfree(pri->mcast_addr);
+	pri->mcast_addr = NULL;
+}
+
 static int mcast_open(void *data)
 {
 	struct mcast_data *pri = data;
@@ -157,7 +165,7 @@ const struct net_user_info mcast_user_info = {
 	.init		= mcast_user_init,
 	.open		= mcast_open,
 	.close	 	= mcast_close,
-	.remove	 	= NULL,
+	.remove	 	= mcast_remove,
 	.set_mtu	= mcast_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,


