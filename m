Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752808AbYLRRMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYLRRMB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYLRRLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:11:48 -0500
Received: from mail09.svc.cra.dublin.eircom.net ([159.134.118.25]:33207 "HELO
	mail09.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751736AbYLRRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:11:47 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/3] virtio: teach virtio_has_feature() about transport features
Date: Thu, 18 Dec 2008 17:10:20 +0000
Message-Id: <1229620222-22216-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.6.0.5
In-Reply-To: <1229620222-22216-1-git-send-email-markmc@redhat.com>
References: <1229620222-22216-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers don't add transport features to their table, so we
shouldn't check these with virtio_check_driver_offered_feature().

We could perhaps add an ->offered_feature() virtio_config_op,
but that perhaps that would be overkill for a consitency check
like this.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 include/linux/virtio_config.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bf8ec28..e4ba694 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -99,7 +99,9 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 	if (__builtin_constant_p(fbit))
 		BUILD_BUG_ON(fbit >= 32);
 
-	virtio_check_driver_offered_feature(vdev, fbit);
+	if (fbit < VIRTIO_TRANSPORT_F_START)
+		virtio_check_driver_offered_feature(vdev, fbit);
+
 	return test_bit(fbit, vdev->features);
 }
 
-- 
1.6.0.5

