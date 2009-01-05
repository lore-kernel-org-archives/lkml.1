Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZAEUNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZAEUNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZAEUMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:12:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:51895 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZAEUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:12:47 -0500
Date: Mon, 5 Jan 2009 12:11:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: [PATCH -next] jbd2: fix printk format warning
Message-Id: <20090105121158.94d990c3.randy.dunlap@oracle.com>
In-Reply-To: <20090105173517.deeff918.sfr@canb.auug.org.au>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49626991.00FD:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix jbd2 printk format:

fs/jbd2/journal.c:848: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'uint32_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/jbd2/journal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090105.orig/fs/jbd2/journal.c
+++ linux-next-20090105/fs/jbd2/journal.c
@@ -845,7 +845,8 @@ static int jbd2_seq_info_show(struct seq
 	seq_printf(seq, "  %ums logging transaction\n",
 	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
 	seq_printf(seq, "  %luus average transaction commit time\n",
-		   do_div(s->journal->j_average_commit_time, 1000));
+		   (unsigned long)do_div(s->journal->j_average_commit_time,
+					1000));
 	seq_printf(seq, "  %lu handles per transaction\n",
 	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
 	seq_printf(seq, "  %lu blocks per transaction\n",
