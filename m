Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZD2LFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZD2LFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZD2LFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:05:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:49806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZD2LFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:05:01 -0400
Date: Wed, 29 Apr 2009 11:04:27 GMT
From: tip-bot for Stuart Bennett <stuart@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
Subject: [tip:tracing/urgent] tracing: x86, mmiotrace: fix range test
Message-ID: <tip-33015c85995716d03f6293346cf05a1908b0fb9a@git.kernel.org>
Git-Commit-ID: 33015c85995716d03f6293346cf05a1908b0fb9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 11:04:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33015c85995716d03f6293346cf05a1908b0fb9a
Gitweb:     http://git.kernel.org/tip/33015c85995716d03f6293346cf05a1908b0fb9a
Author:     Stuart Bennett <stuart@freedesktop.org>
AuthorDate: Tue, 28 Apr 2009 20:17:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 11:32:22 +0200

tracing: x86, mmiotrace: fix range test

Matching on (addr == (p->addr + p->len)) causes problems when mappings
are adjacent.

[ Impact: fix mmiotrace confusion on adjacent iomaps ]

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 4f115e0..50dc802 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -87,7 +87,7 @@ static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
 {
 	struct kmmio_probe *p;
 	list_for_each_entry_rcu(p, &kmmio_probes, list) {
-		if (addr >= p->addr && addr <= (p->addr + p->len))
+		if (addr >= p->addr && addr < (p->addr + p->len))
 			return p;
 	}
 	return NULL;
