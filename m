Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbZFIUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbZFIUat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZFIUal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:30:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZFIUal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:30:41 -0400
Date: Tue, 9 Jun 2009 13:30:18 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: nico-linuxsetlocalversion@schottelius.org
Subject: [PATCH] scripts/setlocalversion on readonly source
Message-ID: <alpine.DEB.2.01.0906091323520.6439@bogon>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19Am6ISJEpbSs+vD5LOdGZ9rvU0LvHBOwyJncE
 hqAF7YYgA1P44B6hpDCXdTppMCSn2n0m391+X1xtyTmyXhx4Cu
 RRct/3dDENKfQdcGEMhbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm building kernels with O=/some/dir and at some point 
scripts/setlocalversion is being called, doing:

  + git update-index --refresh --unmerged
  fatal: Unable to create '.git/index.lock': Read-only file system

Not only does it throw this error but it takes quite a long time to run, 
only to fail anyway because the kernel source dir is located on a 
read-only NFS mount.

The following patch makes the error go away:

--- linux-2.6-git/scripts/setlocalversion	2009-05-29 07:14:34.746191990 +0200
+++ /home/dummy/tmp/scripts/setlocalversion.edited	2009-06-09 22:20:29.000000000 +0200
@@ -39,8 +39,8 @@
 	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
-	# Are there uncommitted changes?
-	git update-index --refresh --unmerged > /dev/null
+	# Are there uncommitted changes? (and can we update the repo?)
+	touch . 2>/dev/null && git update-index --refresh --unmerged > /dev/null
 	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
 	    | read dummy; then
 		printf '%s' -dirty


Thanks,
Christian.
-- 
BOFH excuse #426:

internet is needed to catch the etherbunny
