Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbZINFZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbZINFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZINFZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:25:26 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:39887 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZINFZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=GSVFs6we+xbxpH/UzBH3OnOEe2iPOUKhLB5/hGSIN8iwqpHVlRSMKd50YKBqCCl7wX
         DJLrFlY/X7afMhk72Yz2LCNw5OqLKX1ZAUiFMKK1uex9HJzt5XjkBTqyQiwVjUfpysWb
         bpAC9sijHJG+LpKItsRQIB/oadSivgl/3g68s=
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 13:25:29 +0800
Message-ID: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
Subject: PATCH: ARCH in builddeb
From: Wei Chong Tan <weichong78@gmail.com>
To: sam@ravnborg.org, max@stro.at, elendil@planet.nl,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was using "make ARCH=i386 deb-pkg" in the kernel on a 64bit machine
and found out that the .deb package created was _amd64.deb.
Consequently, I modify the builddeb script to take into account the
ARCH environment variable.

Thanks,
Tan Wei Chong.

>From 477c02443f0fb5a8e39d607197720fec21cecc8b Mon Sep 17 00:00:00 2001
From: Tan, Wei Chong <weichong78@gmail.com>
Date: Mon, 14 Sep 2009 12:56:55 +0800
Subject: [PATCH] update builddeb script to allow ARCH customization
Signed-off-by: Tan, Wei Chong <weichong78@gmail.com>

---
 scripts/package/builddeb |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 8b357b0..cdb017f 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -24,7 +24,11 @@ create_package() {
 	chmod -R go-w "$pdir"

 	# Create the package
-	dpkg-gencontrol -isp -p$pname -P"$pdir"
+	if [ "$ARCH" = "" ] ; then
+		dpkg-gencontrol -isp -p$pname -P"$pdir"
+	else
+		dpkg-gencontrol -DArchitecture=$ARCH -isp -p$pname -P"$pdir"
+	fi
 	dpkg --build "$pdir" ..
 }

-- 
1.6.0.4
