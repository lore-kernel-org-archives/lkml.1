Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbXFCUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbXFCUoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXFCUo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:44:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52794 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXFCUoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:44:25 -0400
Date: Sun, 3 Jun 2007 22:45:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 04/19] powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES
Message-ID: <20070603204527.GD9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 04/19] powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES
From: Segher Boessenkool <segher@kernel.crashing.org>
Date: Sat, 19 May 2007 18:49:08 +0200

...since this won't work (compiler bug, see <http://gcc.gnu.org/PR31490>).

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/Makefile |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 6238b58..1447c83 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -202,6 +202,14 @@ checkbin:
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
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
