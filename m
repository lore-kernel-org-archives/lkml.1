Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXGQOI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXGQOI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXGQOHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35909 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760730AbXGQOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 03/33] powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES
Date: Tue, 17 Jul 2007 16:08:32 +0200
Message-Id: <1184681343138-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813432423-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Segher Boessenkool <segher@kernel.crashing.org>

...since this won't work (compiler bug, see <http://gcc.gnu.org/PR31490>).

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/Makefile |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index fbafd96..85be605 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -201,6 +201,14 @@ checkbin:
 			false; \
 		fi ; \
 	fi
+	@if test "$(call cc-fullversion)" = "040200" \
+	    && test "x${CONFIG_MODULES}${CONFIG_PPC64}" = "xyy" ; then \
+		echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
+		echo 'kernel with modules enabled.' ; \
+		echo -n '*** Please use a different GCC version or ' ; \
+		echo 'disable kernel modules' ; \
+		false ; \
+	fi
 	@if ! /bin/echo dssall | $(AS) -many -o $(TOUT) >/dev/null 2>&1 ; then \
 		echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build ' ; \
 		echo 'correctly with old versions of binutils.' ; \
-- 
1.5.0.6

