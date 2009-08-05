Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbZHEDon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbZHEDon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 23:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbZHEDol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 23:44:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44883 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021AbZHEDok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 23:44:40 -0400
Date: Wed, 5 Aug 2009 13:44:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jakob Bornecrantz <jakob@vmware.com>, Zhao Yakui <yakui.zhao@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20090805134435.1a5010fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_crtc.c between commit
7781de74568bddfefbd2d32a934a8c791a2420cd ("drm: Small logic fix in
drm_mode_setcrtc") from Linus' tree and commit
58367ed65f30128d8b763bf4c1fb942da49ade15 ("drm: Add the debug info in
generic drm mode by using DRM_DEBUG_KMS") from the drm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_crtc.c
index 33be210,a8c8311..0000000
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@@ -1461,8 -1484,8 +1484,8 @@@ int drm_mode_setcrtc(struct drm_device 
  		goto out;
  	}
  
 -	if (crtc_req->count_connectors > 0 && !mode && !fb) {
 +	if (crtc_req->count_connectors > 0 && (!mode || !fb)) {
- 		DRM_DEBUG("Count connectors is %d but no mode or fb set\n",
+ 		DRM_DEBUG_KMS("Count connectors is %d but no mode or fb set\n",
  			  crtc_req->count_connectors);
  		ret = -EINVAL;
  		goto out;
