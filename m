Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbZLQAVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbZLQAVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762845AbZLQAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:20:59 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:42751 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761066AbZLQAU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:20:58 -0500
Date: Thu, 17 Dec 2009 11:20:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alex Elder <aelder@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
Message-ID: <20091217002007.GF4850@discord.disaster>
References: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com> <20091216135512.2675a0e3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216135512.2675a0e3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
> 
> > One more XFS update for -rc1, now that the new XFS tracing code has
> > been committed.
> 
> Sorry if I have missed it, but have the printk format warnings
> on i386 builds been fixed?

I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....

/me hates gcc's warning inconsistencies with a passion.

> e.g.:
> 
> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>                  from linux-next-20091216/include/trace/define_trace.h:69,
>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_enter':
> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'

Patch that should fix this below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Format xfs_fsblock_t correctly in tracing code.

Fixes printk build warnings on i386.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index c40834b..d4ded59 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -815,7 +815,7 @@ TRACE_EVENT(name, \
 	), \
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
 		  "offset 0x%llx count %zd flags %s " \
-		  "startoff 0x%llx startblock 0x%llx blockcount 0x%llx", \
+		  "startoff 0x%llx startblock %s blockcount 0x%llx", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->ino, \
 		  __entry->size, \
@@ -824,7 +824,7 @@ TRACE_EVENT(name, \
 		  __entry->count, \
 		  __print_flags(__entry->flags, "|", BMAPI_FLAGS), \
 		  __entry->startoff, \
-		  __entry->startblock, \
+		  xfs_fmtfsblock(__entry->startblock), \
 		  __entry->blockcount) \
 )
 DEFINE_IOMAP_EVENT(xfs_iomap_enter);
@@ -1201,7 +1201,7 @@ TRACE_EVENT(name, \
 	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u " \
 		  "prod %u minleft %u total %u alignment %u minalignslop %u " \
 		  "len %u type %s otype %s wasdel %d wasfromfl %d isfl %d " \
-		  "userdata %d firstblock 0x%llx", \
+		  "userdata %d firstblock %s", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->agno, \
 		  __entry->agbno, \
@@ -1220,7 +1220,7 @@ TRACE_EVENT(name, \
 		  __entry->wasfromfl, \
 		  __entry->isfl, \
 		  __entry->userdata, \
-		  __entry->firstblock) \
+		  xfs_fmtfsblock(__entry->firstblock)) \
 )
 
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
