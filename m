Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZBVSzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZBVSzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZBVSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:55:00 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:34597 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZBVSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:54:59 -0500
Date: Sun, 22 Feb 2009 10:54:55 -0800
From: Josh Hunt <josh@scalex86.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       kiran@scalex86.org, mingo@elte.hu
Subject: [PATCH] Fix mkspec to cleanup RPM_BUILD_ROOT
Message-ID: <20090222185455.GB17685@localhost.localdomain>
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

The contents of the %clean section in mkspec is currently commented
out leaving RPM_BUILD_ROOT and its contents on the build machine.
This patch removes it once the rpm build process is complete.

Signed-off-by: Josh Hunt <josh@scalex86.org>
---

Index: linux-2.6/scripts/package/mkspec
===================================================================
--- linux-2.6.orig/scripts/package/mkspec       2009-02-20
15:51:22.000000000 -0800
+++ linux-2.6/scripts/package/mkspec    2009-02-20 16:06:32.000000000
-0800
@@ -96,7 +96,7 @@ echo "%endif"
 
 echo ""
 echo "%clean"
-echo '#echo -rf $RPM_BUILD_ROOT'
+echo 'rm -rf $RPM_BUILD_ROOT'
 echo ""
 echo "%files"
 echo '%defattr (-, root, root)'

