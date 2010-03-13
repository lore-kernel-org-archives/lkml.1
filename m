Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935557Ab0CMAcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:47 -0500
Received: from kroah.org ([198.145.64.141]:46885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935409Ab0CMAb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:27 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.683055392@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>
Subject: [051/145] drm/i915: fix get_core_clock_speed for G33 class desktop chips
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 43bcd61fae05fc6062b4f117c5adb1a72c9f8c57 upstream.

Somehow the case for G33 got dropped while porting from ums code.
This made a 400MHz chip into a 133MHz one which resulted in the
unnecessary enabling of double wide pipe mode which in turn
screwed up the overlay code.

Nothing else (than the overlay code) seems to be affected.

This fixes fdo.org bug #24835

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4322,7 +4322,7 @@ static void intel_init_display(struct dr
 	}
 
 	/* Returns the core display clock speed */
-	if (IS_I945G(dev))
+	if (IS_I945G(dev) || (IS_G33(dev) && ! IS_IGDGM(dev)))
 		dev_priv->display.get_display_clock_speed =
 			i945_get_display_clock_speed;
 	else if (IS_I915G(dev))


