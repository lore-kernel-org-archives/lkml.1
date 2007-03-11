Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXCKXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXCKXXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXCKXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:23:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:35575 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793AbXCKXW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=MhgTXVbD0+gqQCnkf+TLXKnh0dqpEkWMrIcmhjXNRGL13tXWBzAS5LJGJBu5hs1zhfaSHGRotShpKLAsm/xxREGnEU4N6ekmheQPVXgwOTHuHNB6FMGzsyGLMH9bjiWg21m80Cs3aUZCAEhRbCo/0OexsT5SrpU6fbAT1Ouw+uU=
Date: Sun, 11 Mar 2007 16:22:52 -0700
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: video4linux-list@redhat.com
Subject: [PATCH] [REVISED] drivers/media/video/videocodec.c: check kmalloc()
 return value.
Message-Id: <20070311162252.2fc29248.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function videocodec_build_table(), in file drivers/media/video/videocodec.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/media/video/videocodec.c b/drivers/media/video/videocodec.c
index 290e641..f2bbd7a 100644
--- a/drivers/media/video/videocodec.c
+++ b/drivers/media/video/videocodec.c
@@ -348,6 +348,9 @@ #define LINESIZE 100
 	kfree(videocodec_buf);
 	videocodec_buf = kmalloc(size, GFP_KERNEL);
 
+	if (!videocodec_buf)
+		return 0;
+
 	i = 0;
 	i += scnprintf(videocodec_buf + i, size - 1,
 		      "<S>lave or attached <M>aster name  type flags    magic    ");
