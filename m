Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab0CMAUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:38 -0500
Received: from kroah.org ([198.145.64.141]:60645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934870Ab0CMATw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:52 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.712135092@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Baruch Siach <baruch@tkos.co.il>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 029/123] V4L/DVB: v4l: soc_camera: fix bound checking of mbus_fmt[] index
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Baruch Siach <baruch@tkos.co.il>

commit 84f3751d6a6f766780dee509433bf7b3dfcdf465 upstream.

When code <= V4L2_MBUS_FMT_FIXED soc_mbus_get_fmtdesc returns a pointer to
mbus_fmt[x], where x < 0. Fix this.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/soc_mediabus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -134,7 +134,8 @@ EXPORT_SYMBOL(soc_mbus_bytes_per_line);
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code)
 {
-	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
+	if (code - V4L2_MBUS_FMT_FIXED > ARRAY_SIZE(mbus_fmt) ||
+	    code <= V4L2_MBUS_FMT_FIXED)
 		return NULL;
 	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
 }


