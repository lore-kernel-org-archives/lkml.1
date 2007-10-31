Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXJaP3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXJaP3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbXJaPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:25:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760045AbXJaPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:25:01 -0400
Date: Wed, 31 Oct 2007 08:12:08 -0700
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
       Ian Armstrong <ian@iarmst.co.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ian Armstrong <ian@iarmst.demon.co.uk>
Subject: [patch 20/26] V4L: ivtv: fix udma yuv bug
Message-ID: <20071031151208.GU2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-ivtv-fix-udma-yuv-bug.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Ian Armstrong <ian@iarmst.demon.co.uk>

Based on cb50f548c0ee9b2aac39743fc4021a7188825a98 in mainline

[PATCH] V4L: ivtv: fix udma yuv bug

Using udma yuv causes the driver to become locked into that mode. This
prevents use of the mpeg decoder & non-udma yuv output.

This patch clears the operating mode when the device is closed.

Signed-off-by: Ian Armstrong <ian@iarmst.demon.co.uk>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-fileops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -753,6 +753,8 @@ static void ivtv_stop_decoding(struct iv
 	}
 	if (s->type == IVTV_DEC_STREAM_TYPE_YUV && itv->output_mode == OUT_YUV)
 	    itv->output_mode = OUT_NONE;
+	else if (s->type == IVTV_DEC_STREAM_TYPE_YUV && itv->output_mode == OUT_UDMA_YUV)
+	    itv->output_mode = OUT_NONE;
 	else if (s->type == IVTV_DEC_STREAM_TYPE_MPG && itv->output_mode == OUT_MPG)
 	    itv->output_mode = OUT_NONE;
 

-- 
