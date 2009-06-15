Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZFOFyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZFOFyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZFOFyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:54:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46354 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZFOFyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:54:02 -0400
Date: Mon, 15 Jun 2009 08:54:02 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Floris Kraak <randakar@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
In-Reply-To: <20090614205002.GE3187@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0906150853320.23909@melkki.cs.Helsinki.FI>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
 <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
 <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
 <20090614205002.GE3187@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Floris Kraak <randakar@gmail.com>

Some distributions have enabled the gcc flag -Wformat-security by default.
This results in a number of warnings about format arguments to functions,
sometimes in cases where fixing the warning is not likely to actually fix a
bug.  Instead of hand patching a dozens of places (possibly more) that produce
warnings that get ignored anyway we just turn off the flag in the Makefile.

Signed-off-by: Floris Kraak <randakar@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 03373bb..5ef1f72 100644
--- a/Makefile
+++ b/Makefile
@@ -351,7 +351,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration
+		   -Werror-implicit-function-declaration \
+		   -Wno-format-security
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
-- 
1.6.0.4

