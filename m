Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXEKIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXEKIrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXEKIrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:47:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbXEKIrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:47:02 -0400
Date: Fri, 11 May 2007 10:46:56 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Use boot based time for process start time and boot
	time in /proc
Message-ID: <20070511084656.GB31854@redhat.com>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz> <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz> <20070510164047.263a9524.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070510164047.263a9524.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 10, 2007 at 04:40:47PM -0700, Andrew Morton wrote:
> On Thu, 10 May 2007 19:10:42 +0200
> Tomas Janousek <tjanouse@redhat.com> wrote:
> > @@ -918,7 +918,7 @@ struct task_struct {
> >  	unsigned int rt_priority;
> >  	cputime_t utime, stime;
> >  	unsigned long nvcsw, nivcsw; /* context switch counts */
> > -	struct timespec start_time;
> > +	struct timespec start_time, real_start_time;
> 
> no, please prefer to do
> 
> 	struct timespec start_time;
> 	struct timespec real_start_time;
> 
> which gives a nice place to add a comment documenting the field.
> 
> Please document fields.
> 
> What is the difference between start_time and real_start_time?

-------------------------
From: Tomas Janousek <tjanouse@redhat.com>
Date: Fri, 11 May 2007 10:38:47 +0200
Subject: [PATCH] Document start times in struct task_struct

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
---
 include/linux/sched.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7eaa536..b852323 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -918,8 +918,8 @@ struct task_struct {
 	unsigned int rt_priority;
 	cputime_t utime, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time;
-	struct timespec real_start_time;
+	struct timespec start_time; 		/* monotonic time */
+	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
-- 
1.5.1.4


-- 
TJ. (Brno, CZ), BaseOS, Red Hat
