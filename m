Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYGXEys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYGXEys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 00:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYGXEyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 00:54:37 -0400
Received: from ozlabs.org ([203.10.76.45]:60943 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYGXEyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 00:54:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/2] scripts/package: allow custom options to rpm
Message-Id: <1216875061.442739.152826544967.2.gpush@pingu>
In-Reply-To: <1216875061.442005.468797861549.1.gpush@pingu>
To: <linux-kernel@vger.kernel.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Thu, 24 Jul 2008 14:51:01 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a RPMOPTS make variable to allow arbitrary options to be passed
to rpm during 'make rpm-pkg'. For example:

 make RPMOPTS="--define '_topdir /home/jk/rpm'" rpm-pkg

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 scripts/package/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
 
