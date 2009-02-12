Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZBLFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZBLFLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZBLFLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:11:01 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:36872 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZBLFLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:11:00 -0500
Date: Wed, 11 Feb 2009 21:10:57 -0800
From: Josh Hunt <josh@scalex86.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       kiran@scalex86.org, mingo@elte.hu
Subject: [PATCH] Add vmlinux to kernel rpm - updated description
Message-ID: <20090212051057.GC12732@localhost.localdomain>
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

Resending with updated description:

We are building an automated system to test kernels weekly and need to
provide an rpm to our QA dept.  We would like to use the ability to create
kernel rpms already in the kernel's Makefile, but need the vmlinux file
included in the rpm for later debugging.  This patch adds a compressed vmlinux to
the kernel rpm when doing a make rpm-pkg or binrpm-pkg and upon install
places the vmlinux file in /boot.

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

