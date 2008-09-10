Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYIJWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYIJWXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIJWXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:23:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36042 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYIJWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:23:09 -0400
Date: Wed, 10 Sep 2008 16:11:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Cc: ak@linux.intel.com, hare@suse.de
Subject: catch calls of acpi_driver_data on pointer of wrong type
Message-ID: <20080910141151.GA13669@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Catch attempts to use of acpi_driver_data on pointers of wrong type.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Hannes Reinecke <hare@suse.de>

---
commit 76c9074075cd9208cf386f37ebd932a00557643a
tree 02589a15c23f430c7728560e4ba51077d41a6eff
parent d4a51ebfa2ffc3320d7eab269dc1ca84e86719f5
author Pavel <pavel@amd.ucw.cz> Wed, 10 Sep 2008 16:10:28 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 10 Sep 2008 16:10:28 +0200

 include/acpi/acpi_bus.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a5ac0bc..641656e 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -300,7 +300,7 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((d)->driver_data)
+#define acpi_driver_data(d)	((void) (d == (struct acpi_device *) 0), d)->driver_data
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
