Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZLAXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZLAXsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZLAXsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:48:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:38354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754718AbZLAXsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:48:40 -0500
X-Authenticated: #2813124
X-Provags-ID: V01U2FsdGVkX1+Xv+4VoJyX07ntxlYCSmIjbhqjGwOuPpeMFi6UO2
	ABhmFjMu6ufFW8
Subject: [PATCH] uvcvideo: add another YUYV format GUID
From: Daniel Ritz <daniel.ritz@gmx.ch>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       daniel.ritz-ml@swissonline.ch
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 00:48:44 +0100
Message-ID: <1259711324.13720.20.camel@MacRitz2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some unknown reason, on a MacBookPro5,3 the iSight _sometimes_ report
a different video format GUID. This patch add the other (wrong) GUID to
the format table, making the iSight work always w/o other problems.

What it should report: 32595559-0000-0010-8000-00aa00389b71
What it often reports: 32595559-0000-0010-8000-000000389b71

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
---
 drivers/media/video/uvc/uvc_driver.c |    5 +++++
 drivers/media/video/uvc/uvcvideo.h   |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 8756be5..c5af0a2 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -58,6 +58,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.fcc		= V4L2_PIX_FMT_YUYV,
 	},
 	{
+		.name		= "YUV 4:2:2 (YUYV)",
+		.guid		= UVC_GUID_FORMAT_YUY2_2,
+		.fcc		= V4L2_PIX_FMT_YUYV,
+	},
+	{
 		.name		= "YUV 4:2:0 (NV12)",
 		.guid		= UVC_GUID_FORMAT_NV12,
 		.fcc		= V4L2_PIX_FMT_NV12,
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index e7958aa..f18eac2 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -112,6 +112,9 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_YUY2 \
 	{ 'Y',  'U',  'Y',  '2', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_YUY2_2 \
+	{ 'Y',  'U',  'Y',  '2', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0x00, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_NV12 \
 	{ 'N',  'V',  '1',  '2', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-- 
1.6.3.3



