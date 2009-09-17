Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZIQJNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZIQJNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZIQJNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:13:48 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40459 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZIQJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkDG2K1HK+trjMPDEgnRGQLTOQl8SzTgXsEzoqINAEu2e02vk7C31TxWFC1hUyYDJT
         rKlUDCpLeP6qjfEgROb5XjEhxjzNxreNi2QNb/ZGyF4kMZXlOtvx9y3GjUMUUqg97MdR
         3w2WZ/zRqiEzjs6K8ZpyDKalA0AH9ZBkAQGrQ=
Date: Thu, 17 Sep 2009 11:13:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf tools: Increase MAX_EVENT_LENGTH
Message-ID: <20090917091345.GD5184@nowhere>
References: <4AB1F48F.4070807@cn.fujitsu.com> <4AB1F4AB.7050205@cn.fujitsu.com> <20090917090255.GC5184@nowhere> <1253178514.14935.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253178514.14935.4.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 11:08:34AM +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-17 at 11:02 +0200, Frederic Weisbecker wrote:
> > On Thu, Sep 17, 2009 at 04:34:51PM +0800, Li Zefan wrote:
> > > The name length of some trace events is longer than 30, like
> > > sys_enter_sched_get_priority_max and ext4_mb_discard_preallocations.
> > > 
> > > Passing those events to perf-record will fail, try:
> > > 
> > >   # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > ---
> > >  tools/perf/util/parse-events.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > > index 034245e..c9ef944 100644
> > > --- a/tools/perf/util/parse-events.c
> > > +++ b/tools/perf/util/parse-events.c
> > > @@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
> > >  	   (strcmp(evt_dirent.d_name, "..")) &&				       \
> > >  	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
> > >  
> > > -#define MAX_EVENT_LENGTH 30
> > > +#define MAX_EVENT_LENGTH 40
> 
> This is userspace, is there any reason to be cheap with memory like
> this?
> 
> Why not stick in 1024 and be done for a while?
> 


Indeed, we may need to go even further than 40 in the future.
But I guess 512 would be already sufficient.

