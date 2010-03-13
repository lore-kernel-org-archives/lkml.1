Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295Ab0CMBOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:14:41 -0500
Received: from kroah.org ([198.145.64.141]:46585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935298Ab0CMAab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.660418546@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Martin Fuzzey <mfuzzey@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [005/145] V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad 	constant => sizeof conversion.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Martin Fuzzey <mfuzzey@gmail.com>

commit 53f68607caba85db9a73846ccd289e4b7fa96295 upstream.

Regression was caused by my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0
which determined message size using sizeof rather than hardcoded constants.

Unfortunately pwc_set_shutter_speed reuses a 2 byte buffer for a one byte
message too so the sizeof was bogus in this case.

All other uses of sizeof checked and are ok.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pwc/pwc-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -753,7 +753,7 @@ int pwc_set_shutter_speed(struct pwc_dev
 		buf[0] = 0xff; /* fixed */
 
 	ret = send_control_msg(pdev,
-		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
+		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
 
 	if (!mode && ret >= 0) {
 		if (value < 0)


