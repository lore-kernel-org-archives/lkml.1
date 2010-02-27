Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968304Ab0B0NQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:16:36 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56998 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968272Ab0B0NQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:16:35 -0500
X-Greylist: delayed 2460 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 08:16:34 EST
Date: Sat, 27 Feb 2010 13:35:30 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH] 2.6.33: deb-pkg: Fix package creation with arbitrary umask
Message-ID: <20100227123530.GA15985@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The used umask has influence on the permissions of the created files,
resulting in errors such as below when the umask is too restrictive:

dpkg-deb: building package `linux-image-2.6.33' in `../linux-image-2.6.33_2.6.33-3_i386.deb'.
dpkg-deb: control directory has bad permissions 700 (must be >=0755 and <=0775)
make[1]: *** [deb-pkg] Error 2

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 scripts/package/builddeb |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 8b357b0..ddca190 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -21,7 +21,7 @@ create_package() {
 
 	# Fix ownership and permissions
 	chown -R root:root "$pdir"
-	chmod -R go-w "$pdir"
+	chmod -R go=u-w "$pdir"
 
 	# Create the package
 	dpkg-gencontrol -isp -p$pname -P"$pdir"
-- 
1.5.6.5


Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
