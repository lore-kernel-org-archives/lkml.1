Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbXCXNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbXCXNJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXCXNJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:09:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33382 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751036AbXCXNJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:09:18 -0400
Date: Sat, 24 Mar 2007 14:09:21 +0100
From: Adrian Bunk <bunk@stusta.de>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/spi/: fix section mismatches
Message-ID: <20070324130921.GN752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_register_master from .text between 'spi_bitbang_start' (at offset 0x84e11a) and 'bitbang_work'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_alloc_master from .text between 'butterfly_attach' (at offset 0x84e681) and 'at25_remove'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_new_device from .text between 'butterfly_attach' (at offset 0x84e7e4) and 'at25_remove'

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/spi/spi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/spi/spi.c.old	2007-03-24 12:23:38.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/spi/spi.c	2007-03-24 13:21:20.000000000 +0100
@@ -189,8 +189,8 @@
  * this is exported so that for example a USB or parport based adapter
  * driver could add devices (which it would learn about out-of-band).
  */
-struct spi_device *__init_or_module
-spi_new_device(struct spi_master *master, struct spi_board_info *chip)
+struct spi_device *spi_new_device(struct spi_master *master,
+				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
 	struct device		*dev = master->cdev.dev;
@@ -352,8 +352,7 @@
  * the master's methods before calling spi_register_master(); and (after errors
  * adding the device) calling spi_master_put() to prevent a memory leak.
  */
-struct spi_master * __init_or_module
-spi_alloc_master(struct device *dev, unsigned size)
+struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 {
 	struct spi_master	*master;
 
@@ -392,8 +391,7 @@
  * After a successful return, the caller is responsible for calling
  * spi_unregister_master().
  */
-int __init_or_module
-spi_register_master(struct spi_master *master)
+int spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<16) - 1);
 	struct device		*dev = master->cdev.dev;

