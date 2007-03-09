Return-Path: <linux-kernel-owner+w=401wt.eu-S2993031AbXCIHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993031AbXCIHOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993032AbXCIHOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:14:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:5668 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993031AbXCIHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:14:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=p702cWz7ExyyHEHWH/EwiW2nr0vp0QMV2Hj1Ln0zviYz7cl94dIu/V5jwuYCv2GDBE32wKs7p40zydxjBoQw0fd02qeEqIH9Mp7XHV5F1GTdHCa6vEMeQ0hDGqgJZWp1XhycrKF5E3MpUyLjRxE5JIf6Kndwkyv0t/5H/gRmTm4=
Date: Thu, 8 Mar 2007 23:14:01 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/video/videocodec.c: check kmalloc() return
 value.
Message-Id: <20070308231401.42679647.amit2030@gmail.com>
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
index 2ae3fb2..16fc1dd 100644
--- a/drivers/media/video/videocodec.c
+++ b/drivers/media/video/videocodec.c
@@ -348,6 +348,8 @@ #define LINESIZE 100
 	kfree(videocodec_buf);
 	videocodec_buf = (char *) kmalloc(size, GFP_KERNEL);
 
+	if (!videocodec_buf)
+		return 0;
 	i = 0;
 	i += scnprintf(videocodec_buf + i, size - 1,
 		      "<S>lave or attached <M>aster name  type flags    magic    ");
