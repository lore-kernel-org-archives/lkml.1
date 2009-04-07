Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZDGXMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZDGXMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZDGXL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:11:59 -0400
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60569 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDGXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:11:59 -0400
Message-ID: <49DBDDB9.6020409@freemail.hu>
Date: Wed, 08 Apr 2009 01:11:53 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>, video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] uvcvideo: prevent invormation loss with removing implicit
 casting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The uvcvideo driver supports only one input, which is input 0. For all
other input index the return value shall be EINVAL. This patch fixes the
problem when the value 0x80000000 was incorrectly casted and treated as
a zero value.

The patch was tested with v4l-test 0.10 [2] with CNF7129 webcam found on
EeePC 901.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r11217.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29-git13/drivers/media/video/uvc/uvc_v4l2.c.orig	2009-04-06 23:16:06.000000000 +0200
+++ linux-2.6.29-git13/drivers/media/video/uvc/uvc_v4l2.c	2009-04-08 00:37:01.000000000 +0200
@@ -648,7 +648,7 @@ static long uvc_v4l2_do_ioctl(struct fil

 	case VIDIOC_S_INPUT:
 	{
-		u8 input = *(u32 *)arg + 1;
+		u32 input = *(u32 *)arg + 1;

 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
