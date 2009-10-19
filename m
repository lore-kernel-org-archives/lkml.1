Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZJSH52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZJSH52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZJSH5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:57:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbZJSH5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:57:16 -0400
Date: Mon, 19 Oct 2009 07:56:39 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <4AD9EBFD.106@klingt.org>
References: <4AD9EBFD.106@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Fix --delay_secs 0 division by zero
Message-ID: <tip-dc79959aaf80e518741657a702fa2727c86c1189@git.kernel.org>
Git-Commit-ID: dc79959aaf80e518741657a702fa2727c86c1189
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Oct 2009 07:56:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc79959aaf80e518741657a702fa2727c86c1189
Gitweb:     http://git.kernel.org/tip/dc79959aaf80e518741657a702fa2727c86c1189
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Sat, 17 Oct 2009 18:08:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Oct 2009 09:52:39 +0200

perf top: Fix --delay_secs 0 division by zero

Add delay_secs sanity check to handle_keypress,
this fixes a division by zero crash.

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4AD9EBFD.106@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 37512e9..a1b1d10 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -686,6 +686,8 @@ static void handle_keypress(int c)
 	switch (c) {
 		case 'd':
 			prompt_integer(&delay_secs, "Enter display delay");
+			if (delay_secs < 1)
+				delay_secs = 1;
 			break;
 		case 'e':
 			prompt_integer(&print_entries, "Enter display entries (lines)");
