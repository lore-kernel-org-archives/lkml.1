Return-Path: <linux-kernel-owner+w=401wt.eu-S1764420AbZGAAz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764420AbZGAAz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbZGAAej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:39 -0400
Received: from kroah.org ([198.145.64.141]:60261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761427AbZGAAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:23 2009
Message-Id: <20090701002423.303460286@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [patch 033/108] V4L: ivtv/cx18: fix regression: class controls are no longer seen
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=v4l-ivtv-cx18-fix-regression-class-controls-are-no-longer-seen.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

(cherry picked from commit c6711c3e6d4976716633047c0f6bbd953d6831fb)

A previous change (v4l2-common: remove v4l2_ctrl_query_fill_std) broke
the handling of class controls in VIDIOC_QUERYCTRL. The MPEG class control
was broken for all drivers that use the cx2341x module and the USER class
control was broken for ivtv and cx18.

This change adds back proper class control support.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx18/cx18-controls.c |    2 ++
 drivers/media/video/cx2341x.c            |    2 ++
 drivers/media/video/ivtv/ivtv-controls.c |    2 ++
 3 files changed, 6 insertions(+)

--- a/drivers/media/video/cx18/cx18-controls.c
+++ b/drivers/media/video/cx18/cx18-controls.c
@@ -61,6 +61,8 @@ int cx18_queryctrl(struct file *file, vo
 
 	switch (qctrl->id) {
 	/* Standard V4L2 controls */
+	case V4L2_CID_USER_CLASS:
+		return v4l2_ctrl_query_fill(qctrl, 0, 0, 0, 0);
 	case V4L2_CID_BRIGHTNESS:
 	case V4L2_CID_HUE:
 	case V4L2_CID_SATURATION:
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -500,6 +500,8 @@ int cx2341x_ctrl_query(const struct cx23
 	int err;
 
 	switch (qctrl->id) {
+	case V4L2_CID_MPEG_CLASS:
+		return v4l2_ctrl_query_fill(qctrl, 0, 0, 0, 0);
 	case V4L2_CID_MPEG_STREAM_TYPE:
 		return v4l2_ctrl_query_fill(qctrl,
 				V4L2_MPEG_STREAM_TYPE_MPEG2_PS,
--- a/drivers/media/video/ivtv/ivtv-controls.c
+++ b/drivers/media/video/ivtv/ivtv-controls.c
@@ -60,6 +60,8 @@ int ivtv_queryctrl(struct file *file, vo
 
 	switch (qctrl->id) {
 	/* Standard V4L2 controls */
+	case V4L2_CID_USER_CLASS:
+		return v4l2_ctrl_query_fill(qctrl, 0, 0, 0, 0);
 	case V4L2_CID_BRIGHTNESS:
 	case V4L2_CID_HUE:
 	case V4L2_CID_SATURATION:


