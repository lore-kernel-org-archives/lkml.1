Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZD2S6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZD2S6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760360AbZD2S6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:58:35 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:54271 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413AbZD2S6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:58:33 -0400
Message-ID: <49F8A325.7060303@freemail.hu>
Date: Wed, 29 Apr 2009 20:57:41 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: fill the reserved fields of VIDIOC_REQBUFS ioctl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32721; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter of VIDIOC_REQBUFS is a pointer to struct v4l2_requestbuffers.
This structure has reserved fields which has to be filled with zeros
according to the V4L2 API specification, revision 0.24 [1].

The patch was tested with v4l-test 0.13 [2] with vivi driver.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r13696.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c.orig	2009-04-22 05:07:00.000000000 +0200
+++ linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c	2009-04-29 19:07:46.000000000 +0200
@@ -1818,6 +1818,7 @@ static unsigned long cmd_input_size(unsi
 		CMDINSIZE(G_SLICED_VBI_CAP,	sliced_vbi_cap,	type);
 		CMDINSIZE(ENUM_FRAMESIZES,	frmsizeenum,	pixel_format);
 		CMDINSIZE(ENUM_FRAMEINTERVALS,	frmivalenum,	height);
+		CMDINSIZE(REQBUFS,		requestbuffers, memory);
 	default:
 		return _IOC_SIZE(cmd);
 	}
