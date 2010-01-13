Return-Path: <linux-kernel-owner+w=401wt.eu-S1750965Ab0AMBBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965Ab0AMBBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980Ab0AMBA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab0AMBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:55 -0500
Message-Id: <20100113004939.463885987@suse.com>
User-Agent: quilt/0.48-4.4
Date: Tue, 12 Jan 2010 19:49:01 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 6/6] virtio: fix section mismatch warnings
References: <20100113004855.550486769@suse.com>
Content-Disposition: inline; filename=patches.rpmify/virtio-fix-section-mismatch-warnings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch fixes the following warnings by renaming the driver structures
 to be suffixed with _driver.

 WARNING: drivers/virtio/virtio_balloon.o(.data+0x88): Section mismatch in reference from the variable virtio_balloon to the function .devexit.text:virtballoon_remove()

 WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x88): Section mismatch in reference from the variable virtio_rng to the function .devexit.text:virtrng_remove()

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/char/hw_random/virtio-rng.c |    6 +++---
 drivers/virtio/virtio_balloon.c     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -114,7 +114,7 @@ static struct virtio_device_id id_table[
 	{ 0 },
 };
 
-static struct virtio_driver virtio_rng = {
+static struct virtio_driver virtio_rng_driver = {
 	.driver.name =	KBUILD_MODNAME,
 	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
@@ -124,12 +124,12 @@ static struct virtio_driver virtio_rng =
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_rng);
+	return register_virtio_driver(&virtio_rng_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_rng);
+	unregister_virtio_driver(&virtio_rng_driver);
 }
 module_init(init);
 module_exit(fini);
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -266,7 +266,7 @@ static void __devexit virtballoon_remove
 
 static unsigned int features[] = { VIRTIO_BALLOON_F_MUST_TELL_HOST };
 
-static struct virtio_driver virtio_balloon = {
+static struct virtio_driver virtio_balloon_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
@@ -279,12 +279,12 @@ static struct virtio_driver virtio_ballo
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_balloon);
+	return register_virtio_driver(&virtio_balloon_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_balloon);
+	unregister_virtio_driver(&virtio_balloon_driver);
 }
 module_init(init);
 module_exit(fini);


