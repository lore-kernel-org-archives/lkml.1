Return-Path: <linux-kernel-owner+w=401wt.eu-S964904AbZLGRjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbZLGRjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935558AbZLGRix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:38:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935544AbZLGRit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:49 -0500
Date: Mon, 7 Dec 2009 17:36:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jens.axboe@oracle.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, arekm@maven.pl, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, arekm@maven.pl, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091207170033.19230.37688.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170033.19230.37688.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86 insn: Delete empty or incomplete inat-tables.c
Message-ID: <tip-d32ba45503acf9c23b301eba2397ca2ee322627b@git.kernel.org>
Git-Commit-ID: d32ba45503acf9c23b301eba2397ca2ee322627b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d32ba45503acf9c23b301eba2397ca2ee322627b
Gitweb:     http://git.kernel.org/tip/d32ba45503acf9c23b301eba2397ca2ee322627b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 7 Dec 2009 12:00:33 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 18:33:19 +0100

x86 insn: Delete empty or incomplete inat-tables.c

Delete empty or incomplete inat-tables.c if gen-insn-attr-x86.awk
failed, because it causes a build error if user tries to build
kernel next time.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091207170033.19230.37688.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 442b3b3..45b20e4 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -5,7 +5,7 @@
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
-      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@
+      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
 
 $(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
 	$(call cmd,inat_tables)
