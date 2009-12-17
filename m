Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZLQX7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZLQX7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZLQX65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:58:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:52561 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZLQX6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:58:54 -0500
Date: Thu, 17 Dec 2009 23:57:53 GMT
From: "tip-bot for akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org>
References: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk
Message-ID: <tip-8c63450718ea62ee3a70bffde170b4d15fc72d3c@git.kernel.org>
Git-Commit-ID: 8c63450718ea62ee3a70bffde170b4d15fc72d3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c63450718ea62ee3a70bffde170b4d15fc72d3c
Gitweb:     http://git.kernel.org/tip/8c63450718ea62ee3a70bffde170b4d15fc72d3c
Author:     akpm@linux-foundation.org <akpm@linux-foundation.org>
AuthorDate: Thu, 17 Dec 2009 15:26:36 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 15:34:29 -0800

x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk

It says

Warning: objdump version  is older than 2.19
Warning: Skipping posttest.

because it used the wrong field from `objdump -v':

akpm:/usr/src/25> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-objdump -v
GNU objdump 2.16.1
Copyright 2005 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License.  This program has absolutely no warranty.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/tools/chkobjdump.awk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index 0d13cd9..5bbb5a3 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -9,7 +9,7 @@ BEGIN {
 }
 
 /^GNU/ {
-	split($4, ver, ".");
+	split($3, ver, ".");
 	if (ver[1] > od_ver ||
 	    (ver[1] == od_ver && ver[2] >= od_sver)) {
 		exit 1;
