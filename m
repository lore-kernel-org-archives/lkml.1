Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYGaATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYGaATz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbYGaAS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:18:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:37196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbYGaAS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:18:56 -0400
Date: Wed, 30 Jul 2008 16:59:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 40/62] V4L: uvcvideo: Fix a buffer overflow in format
	descriptor parsing
Message-ID: <20080730235917.GN12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-uvcvideo-fix-a-buffer-overflow-in-format-descriptor-parsing.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

(cherry picked from commit 233548a2fd934a0220db8b1521c0bc88c82e5e53)

V4L: uvcvideo: Fix a buffer overflow in format descriptor parsing

Thanks to Oliver Neukum for catching and reporting this bug.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -298,7 +298,8 @@ static int uvc_parse_format(struct uvc_d
 	switch (buffer[2]) {
 	case VS_FORMAT_UNCOMPRESSED:
 	case VS_FORMAT_FRAME_BASED:
-		if (buflen < 27) {
+		n = buffer[2] == VS_FORMAT_UNCOMPRESSED ? 27 : 28;
+		if (buflen < n) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
 			       "interface %d FORMAT error\n",
 			       dev->udev->devnum,

-- 
