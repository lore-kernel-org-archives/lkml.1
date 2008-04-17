Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYDQBJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYDQBJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYDQBG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:56 -0400
Received: from sous-sol.org ([216.99.217.87]:58774 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYDQBGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:54 -0400
Message-Id: <20080417010311.217742919@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Krufky <mkrufky@infradead.org>, hverkuil@xs4all.nl,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       ian@iarmst.demon.co.uk, mchehab@infradead.org
Subject: V4L: ivtv: Add missing sg_init_table()
Content-Disposition: inline; filename=v4l-ivtv-add-missing-sg_init_table.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ian Armstrong <ian@iarmst.demon.co.uk>

upstream commit: 165e1213e13b49761f8b3fd9314701f83cf3db3a

If a dma transfer is attempted for either yuv or framebuffer output, a
missing sg_init_table() call causes a kernel BUG in scatterlist.h if
CONFIG_DEBUG_SG is set.

Signed-off-by: Ian Armstrong <ian@iarmst.demon.co.uk>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/media/video/ivtv/ivtv-driver.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -687,6 +687,9 @@ static int __devinit ivtv_init_struct1(s
 	itv->vbi.in.type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
 	itv->vbi.sliced_in = &itv->vbi.in.fmt.sliced;
 
+	/* Init the sg table for osd/yuv output */
+	sg_init_table(itv->udma.SGlist, IVTV_DMA_SG_OSD_ENT);
+
 	/* OSD */
 	itv->osd_global_alpha_state = 1;
 	itv->osd_global_alpha = 255;

-- 
