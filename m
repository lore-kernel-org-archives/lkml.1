Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZIQJC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZIQJC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZIQJC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:02:56 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60688 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZIQJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fWlDFvjiA1QEitu7VQQChq5BJs6Ary5bDYtXuUXlkUFlc4QJL0Ic7yKdAxt393w6DY
         LVjdOYJVkie5eniAA+RPAVrGQaeya5x2V2EOKIMlVOEvc03Uopv9JP6Z8DGMWJEQTXpZ
         q0A8YykJ17Gd/vOFEbQSzGp5nGLLLrNUQnKK0=
Date: Thu, 17 Sep 2009 11:02:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf tools: Increase MAX_EVENT_LENGTH
Message-ID: <20090917090255.GC5184@nowhere>
References: <4AB1F48F.4070807@cn.fujitsu.com> <4AB1F4AB.7050205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB1F4AB.7050205@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:34:51PM +0800, Li Zefan wrote:
> The name length of some trace events is longer than 30, like
> sys_enter_sched_get_priority_max and ext4_mb_discard_preallocations.
> 
> Passing those events to perf-record will fail, try:
> 
>   # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  tools/perf/util/parse-events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 034245e..c9ef944 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
>  	   (strcmp(evt_dirent.d_name, "..")) &&				       \
>  	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
>  
> -#define MAX_EVENT_LENGTH 30
> +#define MAX_EVENT_LENGTH 40



Ack too.

Thanks Li!

  
>  int valid_debugfs_mount(const char *debugfs)
>  {
> -- 
> 1.6.3
> 

