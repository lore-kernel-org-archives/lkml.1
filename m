Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935904Ab0CMAxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:53:36 -0500
Received: from kroah.org ([198.145.64.141]:46956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935439Ab0CMAbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:40 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002710.904871308@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       maximilian attems <max@stro.at>
Subject: [065/145] V4L/DVB (13148): uvcvideo: Handle V4L2_CTRL_TYPE_BUTTON control type in VIDIOC_QUERYCTRL
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit f4eabafeb3ea41801260fba624cbf2da971d19f8 upstream.

Return minimum, maximum and step set to 0 without querying the hardware.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -826,6 +826,13 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 		ret = 0;
 		goto out;
 
+	case V4L2_CTRL_TYPE_BUTTON:
+		v4l2_ctrl->minimum = 0;
+		v4l2_ctrl->maximum = 0;
+		v4l2_ctrl->step = 0;
+		ret = 0;
+		goto out;
+
 	default:
 		break;
 	}


