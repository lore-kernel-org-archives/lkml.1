Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935585Ab0CMAco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:44 -0500
Received: from kroah.org ([198.145.64.141]:46850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935400Ab0CMAbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:21 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.257615380@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@linux.ie>
Subject: [046/145] drm/radeon/kms: Forbid creation of framebuffer with no valid GEM object
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jerome Glisse <jglisse@redhat.com>

commit 7e71c9e2e7704ebf044d4a964e02fbd2098a173f upstream.

This will avoid oops if at later point the fb is use. Trying to create
a framebuffer with no valid GEM object is bogus and should be forbidden
as this patch does.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -599,7 +599,11 @@ radeon_user_framebuffer_create(struct dr
 	struct drm_gem_object *obj;
 
 	obj = drm_gem_object_lookup(dev, file_priv, mode_cmd->handle);
-
+	if (obj ==  NULL) {
+		dev_err(&dev->pdev->dev, "No GEM object associated to handle 0x%08X, "
+			"can't create framebuffer\n", mode_cmd->handle);
+		return NULL;
+	}
 	return radeon_framebuffer_create(dev, mode_cmd, obj);
 }
 


