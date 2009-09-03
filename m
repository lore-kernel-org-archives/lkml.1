Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZICO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZICO2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZICO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:28:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZICO2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:28:14 -0400
Date: Thu, 3 Sep 2009 14:27:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Seek to the end of the header area
Message-ID: <tip-2e01d1791168bb824226d8cc70e50374767dcc42@git.kernel.org>
Git-Commit-ID: 2e01d1791168bb824226d8cc70e50374767dcc42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 14:27:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e01d1791168bb824226d8cc70e50374767dcc42
Gitweb:     http://git.kernel.org/tip/2e01d1791168bb824226d8cc70e50374767dcc42
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 16:21:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 16:21:11 +0200

perf tools: Seek to the end of the header area

Leave the input fd at the data area.

It does not matter right now - but seeking at the end of it
certainly did not make sense.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a37a222..ec4d4c2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -237,7 +237,7 @@ struct perf_header *perf_header__read(int fd)
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset, SEEK_SET);
 
 	self->frozen = 1;
 
