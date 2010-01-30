Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705Ab0A3U6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0A3U6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0A3U6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:58:36 -0500
Received: from mail-qy0-f181.google.com ([209.85.221.181]:49103 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0A3U6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:58:35 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2010 15:58:35 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=ZI7ERkOdZ6nltGo1brkAbyGvyh3wCyOML0JWC7/XgpDKGLQ7SHJbaziwqAQuDRkLc8
         lYmCKwQP8rTUZsFwaqyvG2Pr4Qs6OKC461fMOq9LIvEXKSCm1SbiQb4Fa+h9w+0CqlEJ
         KXDj/PHQGUviXCU44egzSIPEkSaK69g65R08I=
From: John Kacur <jkacur@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] =?utf-8?q?radeon=5Fagp:=20Fix=20warning,=20format=20=E2=80=98%d=E2=80=99=20expects=20type=20=E2=80=98int=E2=80=99,=20but=20argument=204=20has=20type=20=E2=80=98size=5Ft=E2=80=99?=
Date: Sat, 30 Jan 2010 21:51:09 +0100
Message-Id: <1264884670-28211-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
References: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning by using %zu instead of %d for size_t

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_agp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index c9ad7f5..1c4e523 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -134,7 +134,7 @@ int radeon_agp_init(struct radeon_device *rdev)
 	int ret;
 
 	if (rdev->ddev->agp->agp_info.aper_size < 32) {
-		dev_warn(rdev->dev, "AGP aperture to small (%dM) "
+		dev_warn(rdev->dev, "AGP aperture to small (%zuM) "
 			"need at least 32M, disabling AGP\n",
 			rdev->ddev->agp->agp_info.aper_size);
 		return -EINVAL;
-- 
1.6.0.6

