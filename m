Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYLTAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYLTAiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 19:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYLTAiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 19:38:02 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:55489 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYLTAiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 19:38:00 -0500
Message-ID: <494C3E20.1070800@oracle.com>
Date: Fri, 19 Dec 2008 16:36:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next/mmotm] media/video/tuner: fix tuner_ioctl build error
References: <200812192254.mBJMsfia029162@imap1.linux-foundation.org>
In-Reply-To: <200812192254.mBJMsfia029162@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494C3E30.001F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix drivers/media/video/tuner-core.c so that it will build when
CONFIG_VIDEO_ALLOW_V4L1=n:

drivers/media/video/tuner-core.c:1111: error: 'tuner_ioctl' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: v4l-dvb-maintainer@linuxtv.org
cc: video4linux-list@redhat.com
---
 drivers/media/video/tuner-core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- mmotm-2008-1219-1438.orig/drivers/media/video/tuner-core.c
+++ mmotm-2008-1219-1438/drivers/media/video/tuner-core.c
@@ -919,6 +919,11 @@ static int tuner_ioctl(struct v4l2_subde
 	}
 	return -ENOIOCTLCMD;
 }
+#else
+static int tuner_ioctl(struct v4l2_subdev *sd, int cmd, void *arg)
+{
+	return -ENOIOCTLCMD;
+}
 #endif
 
 static int tuner_s_config(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *cfg)

-- 
~Randy
