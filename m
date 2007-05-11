Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXEKGry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXEKGry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXEKGrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:47:47 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:59645 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXEKGrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:47:46 -0400
Date: Fri, 11 May 2007 16:47:45 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix warning when building fs/afs/super.c
Message-ID: <20070511064745.GD15955@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix build waning in fs/afs/super.c

fs/afs/super.c: In function 'afs_parse_options':
fs/afs/super.c:153: warning: passing argument 2 of 'match_token' discards qualifiers from pointer target type

AFS declares it's match_table as const, which is discrded in lib/parser.c.
match_token() doesn't modify the table so making it const should be safe.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 include/linux/parser.h |    2 +-
 lib/parser.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: working/include/linux/parser.h
===================================================================
--- working.orig/include/linux/parser.h
+++ working/include/linux/parser.h
@@ -25,7 +25,7 @@ typedef struct {
 	char *to;
 } substring_t;
 
-int match_token(char *, match_table_t table, substring_t args[]);
+int match_token(char *, const match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
Index: working/lib/parser.c
===================================================================
--- working.orig/lib/parser.c
+++ working/lib/parser.c
@@ -100,7 +100,7 @@ static int match_one(char *s, const char
  * format identifiers which will be taken into account when matching the
  * tokens, and whose locations will be returned in the @args array.
  */
-int match_token(char *s, match_table_t table, substring_t args[])
+int match_token(char *s, const match_table_t table, substring_t args[])
 {
 	const struct match_token *p;
 
Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
