Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZIQJIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZIQJIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIQJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:08:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZIQJIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:08:38 -0400
Subject: Re: [PATCH 2/2] perf tools: Increase MAX_EVENT_LENGTH
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090917090255.GC5184@nowhere>
References: <4AB1F48F.4070807@cn.fujitsu.com>
	 <4AB1F4AB.7050205@cn.fujitsu.com>  <20090917090255.GC5184@nowhere>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 11:08:34 +0200
Message-Id: <1253178514.14935.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 11:02 +0200, Frederic Weisbecker wrote:
> On Thu, Sep 17, 2009 at 04:34:51PM +0800, Li Zefan wrote:
> > The name length of some trace events is longer than 30, like
> > sys_enter_sched_get_priority_max and ext4_mb_discard_preallocations.
> > 
> > Passing those events to perf-record will fail, try:
> > 
> >   # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  tools/perf/util/parse-events.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 034245e..c9ef944 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
> >  	   (strcmp(evt_dirent.d_name, "..")) &&				       \
> >  	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
> >  
> > -#define MAX_EVENT_LENGTH 30
> > +#define MAX_EVENT_LENGTH 40

This is userspace, is there any reason to be cheap with memory like
this?

Why not stick in 1024 and be done for a while?

