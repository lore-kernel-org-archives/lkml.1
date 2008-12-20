Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYLTOhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYLTOhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYLTOat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:49 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41318 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 13/26] scripts/package: allow custom options to rpm
Date: Sat, 20 Dec 2008 15:31:24 +0100
Message-Id: <1229783497-19550-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

Add a RPMOPTS make variable to allow arbitrary options to be passed
to rpm during 'make rpm-pkg'. For example:

 make RPMOPTS="--define '_topdir /home/jk/rpm'" rpm-pkg

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 5e32607..c162409 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -47,7 +47,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
+	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
 	rm ../$(KERNELPATH).tar.gz
 
 clean-files := $(objtree)/kernel.spec
@@ -64,7 +64,8 @@ binrpm-pkg: $(objtree)/binkernel.spec FORCE
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) --define "_builddir $(srctree)" --target $(UTS_MACHINE) -bb $<
+	$(RPM) $(RPMOPTS) --define "_builddir $(srctree)" --target \
+		$(UTS_MACHINE) -bb $<
 
 clean-files += $(objtree)/binkernel.spec
 
-- 
1.6.0.2.GIT

