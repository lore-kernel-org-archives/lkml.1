Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZG0QTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZG0QTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZG0QTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:19:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44514 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZG0QTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:19:37 -0400
Date: Mon, 27 Jul 2009 18:16:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/12] tools: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271815440.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

symstrs has already been tested.  It seems that this test should be on the
recently returned value secstrs.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 tools/perf/util/symbol.c            |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2810605..b4fe057 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -565,7 +565,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		goto out_elf_end;
 
 	secstrs = elf_getdata(sec_strndx, NULL);
-	if (symstrs == NULL)
+	if (secstrs == NULL)
 		goto out_elf_end;
 
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
