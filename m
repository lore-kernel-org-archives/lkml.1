Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYFBPrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYFBPrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYFBPq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:46:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYFBPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:46:57 -0400
Subject: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
In-Reply-To: <200804241931.m3OJVQiR022368@hera.kernel.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 16:46:51 +0100
Message-Id: <1212421611.16924.246.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were removed in commit 26d507fcfef7f7d0cd2eec874a87169cc121c835:
V4L/DVB (7166): [v4l] Add new user class controls and deprecate others

> -#define V4L2_CID_HCENTER               (V4L2_CID_BASE+22)
> -#define V4L2_CID_VCENTER               (V4L2_CID_BASE+23)
> -#define V4L2_CID_LASTP1                        (V4L2_CID_BASE+24) /*
> last CID + 1 */
> +
> +/* Deprecated, use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
> +#define V4L2_CID_HCENTER_DEPRECATED    (V4L2_CID_BASE+22)
> +#define V4L2_CID_VCENTER_DEPRECATED    (V4L2_CID_BASE+23)

But there was no warning in Documentation/feature-removal-schedule.txt
and I'm receiving reports that it's breaking userspace apps (the
gstreamer-v4l2 plugin breaks in Fedora rawhide). You can't just pull
things from the published userspace API like that.

Please can we revert the addition of _DEPRECATED to these ioctl
definitions. Perhaps we can add a runtime warning if they actually get
used? Or a compile-time warning if we can manage that?

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c141118..4a535ea 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -865,9 +865,9 @@ struct v4l2_querymenu
 #define V4L2_CID_HFLIP			(V4L2_CID_BASE+20)
 #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
 
-/* Deprecated, use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
-#define V4L2_CID_HCENTER_DEPRECATED	(V4L2_CID_BASE+22)
-#define V4L2_CID_VCENTER_DEPRECATED	(V4L2_CID_BASE+23)
+/* Deprecated; use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
+#define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
+#define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
 
 #define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24)
 enum v4l2_power_line_frequency {


-- 
dwmw2

