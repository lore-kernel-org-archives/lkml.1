Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab0BCQtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:49:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab0BCQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:49:36 -0500
X-Authority-Analysis: v=1.0 c=1 a=OWzVTy7wDO4A:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=vOx2YAukEyAz7Fq_kG0A:9 a=WShcrsR0n-9WYKtAh7xWqd1rJGQA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][linux-next] kconfig: simplify LSMOD= handling
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Anibal Monsalve Salazar <anibal@debian.org>
In-Reply-To: <20100203162014.GA10956@sepie.suse.cz>
References: <20100203154605.461025238@goodmis.org>
	 <20100203154906.499020585@goodmis.org>
	 <20100203160708.GA9035@sepie.suse.cz>
	 <1265213553.24386.0.camel@gandalf.stny.rr.com>
	 <20100203162014.GA10956@sepie.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:49:21 -0500
Message-ID: <1265215761.24386.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This has been merged into my for-next branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git
for-linus-2


Michal Marek (1):
      kconfig: Simplify LSMOD= handling

----
 scripts/kconfig/Makefile |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)
---------------------------
commit 3cebbb81c7e75321e25cc586d07a25a3d98278fc
Author: Michal Marek <mmarek@suse.cz>
Date:   Wed Feb 3 17:20:14 2010 +0100

    kconfig: Simplify LSMOD= handling
    
    Signed-off-by: Michal Marek <mmarek@suse.cz>
    LKML-Reference: <20100203162014.GA10956@sepie.suse.cz>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


