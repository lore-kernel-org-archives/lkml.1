Return-Path: <linux-kernel-owner+w=401wt.eu-S935507AbZLGQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935507AbZLGQ4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935468AbZLGQ4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:56:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935411AbZLGQ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:56:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 1/5] x86 insn: Delete empty or incomplete
	inat-tables.c
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 07 Dec 2009 12:00:33 -0500
Message-ID: <20091207170033.19230.37688.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete empty or incomplete inat-tables.c if gen-insn-attr-x86.awk
failed, because it causes a build error if user tries to build
kernel next time.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
