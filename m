Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbYJYUB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbYJYUB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYJYUBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:01:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:58323 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYJYUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CnuNAh16nORxbTFx9alDsQfoV8sXBthq9EIiVAdhLxGiA5bjVWkdpTiNxqOR2jdVop
         Ch1KkgySrDKJcn2LgwNlqdthZUuhTcf1z1Tp5q5rJVhx9p2vRowmixSrZn8EVNgTsi7l
         JoN8OrktVhmg9wGuTS171BXksXMGkHCkKFozM=
Date: Sat, 25 Oct 2008 22:00:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] fbcon: don't inline updatescrollmode
Message-ID: <20081025200055.GE10932@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updatescrollmode is marked inline, but it's big and is called only from
non-critical codepaths (fbcon_resize, fbcon_switch, fbcon_modechanged).
Dropping it saves almost 800 bytes of text size.

   text    data     bss     dec     hex filename
  23859     287    8448   32594    7f52 drivers/video/console/fbcon.o.before
  23065     287    8448   31800    7c38 drivers/video/console/fbcon.o.after

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/fbcon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 64b3d30..b92947d 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2118,7 +2118,7 @@ static void fbcon_bmove_rec(struct vc_data *vc, struct display *p, int sy, int s
 		   height, width);
 }
 
-static __inline__ void updatescrollmode(struct display *p,
+static void updatescrollmode(struct display *p,
 					struct fb_info *info,
 					struct vc_data *vc)
 {
-- 
1.5.6.4

