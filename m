Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXIXQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXIXQYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbXIXQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:24:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47144 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbXIXQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:36 -0400
Date: Mon, 24 Sep 2007 09:19:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [01/50] V4L: ivtv: fix VIDIOC_S_FBUF: new OSD values were never set
Message-ID: <20070924161944.GB13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-ivtv-fix-vidioc_s_fbuf-new-osd-values-were-never-set.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>

cherry picked from commit c3624f99a8c06cfe75e0b06f23a7f7cea9d2d5ff

ivtv: fix VIDIOC_S_FBUF support: new OSD values were never actually set.

The values set with VIDIOC_S_FBUF were not actually used until the next
VIDIOC_S_FMT. Fixed.


Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/media/video/ivtv/ivtv-ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1183,6 +1183,7 @@ int ivtv_v4l2_ioctls(struct ivtv *itv, s
 		itv->osd_global_alpha_state = (fb->flags & V4L2_FBUF_FLAG_GLOBAL_ALPHA) != 0;
 		itv->osd_local_alpha_state = (fb->flags & V4L2_FBUF_FLAG_LOCAL_ALPHA) != 0;
 		itv->osd_color_key_state = (fb->flags & V4L2_FBUF_FLAG_CHROMAKEY) != 0;
+		ivtv_set_osd_alpha(itv);
 		break;
 	}
 

-- 
