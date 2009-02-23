Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZBWOIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZBWOIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZBWOIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:08:06 -0500
Received: from mout2.freenet.de ([195.4.92.92]:46203 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZBWOIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:08:06 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: Linux 2.6.29-rc6 - Fix oops in i915_gem_retire_requests
Date: Mon, 23 Feb 2009 15:07:57 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231507.58049.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an oops in i915_gem_retire_requests()

dev_priv->hw_status_page can be NULL, if i915_gem_retire_requests()
is called from i915_gem_busy_ioctl().

Signed-off-by Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 drivers/gpu/drm/i915/i915_gem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 25b3374..28b726d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1051,6 +1051,9 @@ i915_gem_retire_requests(struct drm_device *dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	uint32_t seqno;
 
+	if (!dev_priv->hw_status_page)
+		return;
+
 	seqno = i915_get_gem_seqno(dev);
 
 	while (!list_empty(&dev_priv->mm.request_list)) {
-- 
1.6.0.6
