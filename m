Return-Path: <linux-kernel-owner+w=401wt.eu-S1763865AbYHEUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763865AbYHEUu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbYHEUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:50:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271AbYHEUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uwgssqZtT9Cd25bm+VIr7t6lqMwo9LDyEydy7cXZVhOCT+AgKZD2DgRw6bMMqbdW3m
         FPqWAlMzUDMhrr5o20w7nuX14fDjuslwP89LgLgwwgt9pj/7XytepCPdKIabafUjzH2y
         QsJv2tCLDPrDX0Je7+LQRXYGWUPXFAL7isMr8=
Date: Wed, 6 Aug 2008 00:50:41 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080805205041.GD17320@orion>
References: <20080805201036.GC17320@orion> <20080805202948.GL22600@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805202948.GL22600@mail.oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:29:48PM -0700, Joel Becker wrote:
> 	suseconds_t is a signed long.  Can you change the format to %ld
> and cast to long?  Unfortunately, we need the cast, as sparc64 and
> parisc treat it as int.

Then we should change cast from unsigned long to long for every tv_usec, right?


From: Alexander Beregalov <a.beregalov@gmail.com>

ocfs2/cluster/netdebug.c: fix warning

fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
     type 'long unsigned int', but argument 17 has type 'suseconds_t'

Joel Becker wrote:
>       suseconds_t is a signed long.  Can you change the format to %ld
> and cast to long?  Unfortunately, we need the cast, as sparc64 and
> parisc treat it as int.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 
 fs/ocfs2/cluster/netdebug.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index d8bfa0e..52276c0 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -138,20 +138,20 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   "  message id:   %d\n"
 			   "  message type: %u\n"
 			   "  message key:  0x%08x\n"
-			   "  sock acquiry: %lu.%lu\n"
-			   "  send start:   %lu.%lu\n"
-			   "  wait start:   %lu.%lu\n",
+			   "  sock acquiry: %lu.%ld\n"
+			   "  send start:   %lu.%ld\n"
+			   "  wait start:   %lu.%ld\n",
 			   nst, (unsigned long)nst->st_task->pid,
 			   (unsigned long)nst->st_task->tgid,
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
 			   nst->st_sock_time.tv_sec,
-			   (unsigned long)nst->st_sock_time.tv_usec,
+			   (long)nst->st_sock_time.tv_usec,
 			   nst->st_send_time.tv_sec,
-			   (unsigned long)nst->st_send_time.tv_usec,
+			   (long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
-			   nst->st_status_time.tv_usec);
+			   (long)nst->st_status_time.tv_usec);
 	}
 
 	spin_unlock(&o2net_debug_lock);
@@ -276,7 +276,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, (unsigned long)TV.tv_usec
+#define TV_SEC_USEC(TV) TV.tv_sec, (long)TV.tv_usec
 
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
@@ -309,12 +309,12 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			   "  remote node:     %s\n"
 			   "  page off:        %zu\n"
 			   "  handshake ok:    %u\n"
-			   "  timer:           %lu.%lu\n"
-			   "  data ready:      %lu.%lu\n"
-			   "  advance start:   %lu.%lu\n"
-			   "  advance stop:    %lu.%lu\n"
-			   "  func start:      %lu.%lu\n"
-			   "  func stop:       %lu.%lu\n"
+			   "  timer:           %lu.%ld\n"
+			   "  data ready:      %lu.%ld\n"
+			   "  advance start:   %lu.%ld\n"
+			   "  advance stop:    %lu.%ld\n"
+			   "  func start:      %lu.%ld\n"
+			   "  func stop:       %lu.%ld\n"
 			   "  func key:        %u\n"
 			   "  func type:       %u\n",
 			   sc,
