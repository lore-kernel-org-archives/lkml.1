Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZAWBHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZAWBHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZAWBGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:06:54 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:57920 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZAWBGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:06:54 -0500
X-Greylist: delayed 3002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 20:06:53 EST
Date: Thu, 22 Jan 2009 16:16:47 -0800
From: Josh Hunt <josh@scalex86.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       kiran@scalex86.org
Subject: [PATCH] Add vmlinux to kernel rpm
Message-ID: <20090123001647.GB31925@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds compressed vmlinux to rpm when doing "make {rpm-pkg,binrpm-pkg}".
Installs vmlinux.bz2 to /boot.

Signed-off-by: Josh Hunt <josh@scalex86.org>

Index: linux-2.6.28/scripts/package/mkspec
===================================================================
--- linux-2.6.28.orig/scripts/package/mkspec    2008-12-24
15:26:37.000000000 -0800
+++ linux-2.6.28/scripts/package/mkspec    2009-01-21
16:53:03.000000000 -0800
@@ -86,6 +86,14 @@ echo "%endif"
 echo 'cp System.map $RPM_BUILD_ROOT'"/boot/System.map-$KERNELRELEASE"

 echo 'cp .config $RPM_BUILD_ROOT'"/boot/config-$KERNELRELEASE"
+
+echo "%ifnarch ppc64"
+echo 'cp vmlinux vmlinux.orig'
+echo 'bzip2 -9 vmlinux'
+echo 'mv vmlinux.bz2
$RPM_BUILD_ROOT'"/boot/vmlinux-$KERNELRELEASE.bz2"
+echo 'mv vmlinux.orig vmlinux'
+echo "%endif"
+
 echo ""
 echo "%clean"
 echo '#echo -rf $RPM_BUILD_ROOT' 
