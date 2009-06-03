Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZFCTtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZFCTtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZFCTtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:49:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:56944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZFCTtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:49:13 -0400
Date: Wed, 3 Jun 2009 19:48:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090603174921.GG7805@ghostprotocols.net>
References: <20090603174921.GG7805@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf_counter tools: Fix off-by-one bug in symbol__new
Message-ID: <tip-18374ab76e3ec1cf1b0ca5a8d08e35cfc5d01669@git.kernel.org>
Git-Commit-ID: 18374ab76e3ec1cf1b0ca5a8d08e35cfc5d01669
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 19:48:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18374ab76e3ec1cf1b0ca5a8d08e35cfc5d01669
Gitweb:     http://git.kernel.org/tip/18374ab76e3ec1cf1b0ca5a8d08e35cfc5d01669
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Jun 2009 14:49:21 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 21:46:59 +0200

perf_counter tools: Fix off-by-one bug in symbol__new

The end is really (start + len - 1). Noticed when synthesizing
the PLT symbols, that are small (16 bytes), and hot on the
start RIP.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20090603174921.GG7805@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index d52a1ae..35ee6de 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -19,7 +19,7 @@ static struct symbol *symbol__new(uint64_t start, uint64_t len,
 			self = ((void *)self) + priv_size;
 		}
 		self->start = start;
-		self->end   = start + len;
+		self->end   = start + len - 1;
 		memcpy(self->name, name, namelen);
 	}
 
