Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0BCQUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:20:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab0BCQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:20:15 -0500
Date: Wed, 3 Feb 2010 17:20:14 +0100
From: Michal Marek <mmarek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Anibal Monsalve Salazar <anibal@debian.org>
Subject: [PATCH] kconfig: simplify LSMOD= handling
Message-ID: <20100203162014.GA10956@sepie.suse.cz>
References: <20100203154605.461025238@goodmis.org>
 <20100203154906.499020585@goodmis.org>
 <20100203160708.GA9035@sepie.suse.cz>
 <1265213553.24386.0.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265213553.24386.0.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/Makefile |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 85b9065..186c466 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -32,11 +32,10 @@ silentoldconfig: $(obj)/conf
 
 # if no path is given, then use src directory to find file
 ifdef LSMOD
-LSMOD_F = $(shell if [ `basename $(LSMOD)` == $(LSMOD) ]; then \
-		echo $(objtree)/$(LSMOD);			\
-	else							\
-		echo $(LSMOD);					\
-	fi)
+LSMOD_F := $(LSMOD)
+ifeq ($(findstring /,$(LSMOD)),)
+  LSMOD_F := $(objtree)/$(LSMOD)
+endif
 endif
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
-- 
1.6.5.3

