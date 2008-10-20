Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYJTXcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYJTXcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYJTXb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:31:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:27340 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJTXb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GkqFGovxx/LFzdR1JCAbveTivw1baLDEl3rgdPz6qVd/r1VjjIP65aYyiOPEAA1kO9
         3Yc6h7jocuTRAdViA/6/xko7LhK7SKIdTbrdFku87ciX5mNwUk+iFinzNYgIfq5RAa/F
         EGilTBtMnABVQM63LH443Q/uxihxyYngzk0P4=
Date: Tue, 21 Oct 2008 03:31:45 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i915: fix build failure in fast_user_write()
Message-ID: <20081020233145.GC21471@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/i915/i915_gem.c: In function 'fast_user_write':
drivers/gpu/drm/i915/i915_gem.c:196: error: 'o' undeclared (first use in this function)
drivers/gpu/drm/i915/i915_gem.c:196: error: (Each undeclared identifier is reported only once
drivers/gpu/drm/i915/i915_gem.c:196: error: for each function it appears in.)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/gpu/drm/i915/i915_gem.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 49c5a17..16afdb5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -182,7 +182,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
  * happens to let us map card memory without taking IPIs.  When the vmap
  * rework lands we should be able to dump this hack.
  */
-static inline int fast_user_write(unsigned long pfn, char __user *user_data, int l)
+static inline int fast_user_write(unsigned long pfn, char __user *user_data,
+				  int i, int o, int l)
 {
 #ifdef CONFIG_HIGHMEM
 	unsigned long unwritten;
@@ -251,7 +252,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 		pfn = (dev->agp->base >> PAGE_SHIFT) + i;
 
-		if (!fast_user_write(pfn, user_data, l)) {
+		if (!fast_user_write(pfn, user_data, i, o, l)) {
 			unsigned long unwritten;
 			char __iomem *vaddr;
 

