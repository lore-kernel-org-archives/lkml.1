Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZJZPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZJZPOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZJZPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:14:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:45568 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZJZPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=icZaCp1MyKWMzySCrfXoryK9cg1e23RASnR0431VcuI64a1L7mRc052aR4Ox3FqRut
         2ilo5GwpBT9MxuuZSxFf9UhICQ28Ha0/D/SaXu03+DZwOZYt1UYgJ+qljQvBB8ubgmYB
         oy6aJVwmJBdH+ZdzBhMhmj5hyQYCaY/RcKsv4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>, Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH -v6 06/13] tracing: add an endian argument to scripts/recordmcount.pl
Date: Mon, 26 Oct 2009 23:13:23 +0800
Message-Id: <3c82af564d70be05b92687949ed134ce034bf8db.1256569489.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS and some other architectures need this argument to handle
big/little endian respectively.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 scripts/Makefile.build  |    1 +
 scripts/recordmcount.pl |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 341b589..0b94d2f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -207,6 +207,7 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index bfb8b2c..465fe5e 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -99,13 +99,13 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV < 8) {
+	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
-my ($arch, $bits, $objdump, $objcopy, $cc,
+my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-- 
1.6.2.1

