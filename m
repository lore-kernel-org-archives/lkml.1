Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZKQP6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZKQP6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZKQP6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:58:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41259 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754661AbZKQP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:58:42 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] vhost: Fix warnings and bad type handling
To: mst@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 17 Nov 2009 15:42:15 +0000
Message-ID: <20091117154213.3683.94554.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/vhost/vhost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 97233d5..46b20f7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -334,7 +334,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EINVAL;
 			break;
 		}
-		r = init_used(vq, (struct vring_used __user *)a.used_user_addr);
+		/* For 32bit we will ignore the top 32bits of the user
+		   data */
+		r = init_used(vq, (struct vring_used __user *)(unsigned long)
+						a.used_user_addr);
 		if (r)
 			break;
 		vq->log_used = !!(a.flags & (0x1 << VHOST_VRING_F_LOG));

