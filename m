Return-Path: <linux-kernel-owner+w=401wt.eu-S2993046AbXCIHWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993046AbXCIHWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993040AbXCIHWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:22:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:36483 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993045AbXCIHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UKhxNSwp43Oby15Pqc2PhMeRwMx2A8ClbqnLmJ9V+IhkWIIUzsPOEzodRVDU+sgau4IBCrnc5P0cfREMlHlupb1JFVQCzpVsZTI3jl8/stbJEk/xDSrZA/K1mQBsHyZPv4Fz+O2nG6w1W/J35JpY+fiqsORECx/JW+i15CwD2ek=
Date: Thu, 8 Mar 2007 23:21:48 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sound/oss/i810_audio.c: check kmalloc() return value.
Message-Id: <20070308232148.247e6734.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function i810_open(), in file sound/oss/i810_audio.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/sound/oss/i810_audio.c b/sound/oss/i810_audio.c
index 240cc79..a415967 100644
--- a/sound/oss/i810_audio.c
+++ b/sound/oss/i810_audio.c
@@ -2580,8 +2580,13 @@ static int i810_open(struct inode *inode
 			if (card->states[i] == NULL) {
 				state = card->states[i] = (struct i810_state *)
 					kmalloc(sizeof(struct i810_state), GFP_KERNEL);
-				if (state == NULL)
+				if (state == NULL) {
+					for (--i; i >= 0; i--) {
+						kfree(card->states[i]);
+						card->states[i] = NULL;
+					}
 					return -ENOMEM;
+				}
 				memset(state, 0, sizeof(struct i810_state));
 				dmabuf = &state->dmabuf;
 				goto found_virt;
