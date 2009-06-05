Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZFECMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZFECMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZFECMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:12:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZFECMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:12:15 -0400
Date: Thu, 4 Jun 2009 22:12:09 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20090605021427.7905.16640.sendpatchset@localhost.localdomain>
In-Reply-To: <20090605021419.7905.89870.sendpatchset@localhost.localdomain>
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain>
Subject: [Patch] kbuild: clean up scripts/headers.sh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'drop' variable is unused.

'ppc' and 'sparc64' directories don't exist in arch/,
and I think their headers can be well exported now, so
just remove them.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

------
diff --git a/scripts/headers.sh b/scripts/headers.sh
index d33426f..0308ecc 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -15,19 +15,12 @@ do_command()
 	fi
 }
 
-# Do not try this architecture
-drop="generic um ppc sparc64 cris"
-
 archs=$(ls ${srctree}/arch)
 
 for arch in ${archs}; do
 	case ${arch} in
 	um)        # no userspace export
 		;;
-	ppc)       # headers exported by powerpc
-		;;
-	sparc64)   # headers exported by sparc
-		;;
 	cris)      # headers export are known broken
 		;;
 	*)
