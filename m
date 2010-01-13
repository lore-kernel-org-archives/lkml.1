Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725Ab0AMKgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0AMKgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714Ab0AMKge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:34677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0AMKgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:33 -0500
Date: Wed, 13 Jan 2010 10:35:46 GMT
From: tip-bot for Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.beregalov@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.beregalov@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262882447-23776-2-git-send-email-a.beregalov@gmail.com>
References: <1262882447-23776-2-git-send-email-a.beregalov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix memory leak: counterwidth
Message-ID: <tip-8d9e503928638fc95317be42c416fb7907322aff@git.kernel.org>
Git-Commit-ID: 8d9e503928638fc95317be42c416fb7907322aff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:35:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d9e503928638fc95317be42c416fb7907322aff
Gitweb:     http://git.kernel.org/tip/8d9e503928638fc95317be42c416fb7907322aff
Author:     Alexander Beregalov <a.beregalov@gmail.com>
AuthorDate: Thu, 7 Jan 2010 19:40:47 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:15 +0100

perf: Fix memory leak: counterwidth

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <1262882447-23776-2-git-send-email-a.beregalov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/values.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 1c15e39..cfa55d6 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -169,6 +169,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 				counterwidth[j], values->value[i][j]);
 		fprintf(fp, "\n");
 	}
+	free(counterwidth);
 }
 
 static void perf_read_values__display_raw(FILE *fp,
