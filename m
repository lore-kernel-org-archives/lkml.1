Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064Ab0AJMij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0AJMij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587Ab0AJMij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:38:39 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:45019 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab0AJMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:38:38 -0500
X-Greylist: delayed 2255 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 07:38:38 EST
Date: Sun, 10 Jan 2010 13:01:00 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] deb-pkg: Fix package creation with arbitrary used umask
Message-ID: <20100110120100.GB16225@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The used umask has influence on the permissions of the created files,
resulting in errors such as:

dpkg-deb: building package `linux-image-2.6.33-rc3' in `../linux-image-2.6.33-rc3_2.6.33-rc3-3_i386.deb'.
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
