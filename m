Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbZLGAXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbZLGAXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbZLGANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:35 -0500
Received: from kroah.org ([198.145.64.141]:34529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbZLGAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:52 2009
Message-Id: <20091207000652.482876972@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [069/119] drm/i915: Select CONFIG_SHMEM
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-select-config_shmem.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit ca9ab10033d190c1ede85fdf456307bdfdabf079 upstream.

The driver requires shmfs as the backing filesystem to handle the buffer
objects, so ensure it is selected if the user chooses to build our
driver.

Fixes: Bug 14662 - Dell E5500 kernel panic with KMS
http://bugzilla.kernel.org/show_bug.cgi?id=14662

The revealing nature of the panic is the NULL function pointer
dereference in read_cache_page_async().

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-tested-by: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -82,6 +82,7 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	select SHMEM
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT


