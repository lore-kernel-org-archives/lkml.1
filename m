Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbZHHJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbZHHJdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbZHHJdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:33:53 -0400
Received: from server1.wserver.cz ([82.113.45.157]:43687 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795AbZHHJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:33:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: pavel@ucw.cz, swetland@google.com, ibm@android.com, san@android.com,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Staging: dream, fix buf overflow
Date: Sat,  8 Aug 2009 11:33:58 +0200
Message-Id: <1249724038-1011-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not even compile-tested. I don't have an arm toolchain.
--

In vfe_send_msg_no_payload there is a wrong struct vfe_message allocation.
It allocates only sizeof(pointer to vfe_message) for a whole structure.
Add a dereference to the sizeof to allocate sizeof(vfe_message).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/staging/dream/camera/msm_vfe8x_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/msm_vfe8x_proc.c b/drivers/staging/dream/camera/msm_vfe8x_proc.c
index bb65013..5436f71 100644
--- a/drivers/staging/dream/camera/msm_vfe8x_proc.c
+++ b/drivers/staging/dream/camera/msm_vfe8x_proc.c
@@ -818,7 +818,7 @@ static void vfe_send_msg_no_payload(enum VFE_MESSAGE_ID id)
 {
 	struct vfe_message *msg;
 
-	msg = kzalloc(sizeof(msg), GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg)
 		return;
 
-- 
1.6.3.3

