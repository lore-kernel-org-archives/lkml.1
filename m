Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZJFCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZJFCfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZJFCfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:35:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZJFCfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:35:47 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/1] perf tools: elf_sym__is_function should accept "zero" sized functions
Date: Mon,  5 Oct 2009 23:35:03 -0300
Message-Id: <1254796503-27203-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asm routines that end up having size equal to zero are not really zero
sized, and as now we do kernel_maps__fixup_sym_end, at least for kernel
routines this gets fixed.

A similar fixup needs to be done for the userspace bits as well, but as
this fixup started only because in /proc/kallsyms we don't have the end
address nor the function size, it appeared here first.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e3eebdd..582ce72 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -396,8 +396,7 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_FUNC &&
 	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF &&
-	       sym->st_size != 0;
+	       sym->st_shndx != SHN_UNDEF;
 }
 
 static inline int elf_sym__is_label(const GElf_Sym *sym)
-- 
1.6.2.5

