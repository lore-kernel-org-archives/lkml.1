Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZIQJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZIQJBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZIQJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:01:51 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50033 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZIQJBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DvfhE3Q/MhsPrms2TB8lgS49NsUC2V9Za2udC0eA+1Zbbf6ZVwEoOCFskIaHT9DhVF
         tYmHEz5zl9R6o8GydGtiCKDyjJU092daLSfir1Utu+KhgCgm+sVpU4BTScmhmqOaIho/
         pC3fhU0dGnyfZYMjkRkjU8JDuoaj188/rqosY=
Date: Thu, 17 Sep 2009 11:01:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf tools: Fix memory leak in read_ftrace_printk()
Message-ID: <20090917090149.GB5184@nowhere>
References: <4AB1F48F.4070807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB1F48F.4070807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:34:23PM +0800, Li Zefan wrote:
> get_tracing_file() should be paired with put_tracing_file().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>



Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  tools/perf/util/trace-event-info.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index 6c9302a..1fd824c 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -458,7 +458,7 @@ static void read_proc_kallsyms(void)
>  static void read_ftrace_printk(void)
>  {
>  	unsigned int size, check_size;
> -	const char *path;
> +	char *path;
>  	struct stat st;
>  	int ret;
>  
> @@ -468,14 +468,15 @@ static void read_ftrace_printk(void)
>  		/* not found */
>  		size = 0;
>  		write_or_die(&size, 4);
> -		return;
> +		goto out;
>  	}
>  	size = get_size(path);
>  	write_or_die(&size, 4);
>  	check_size = copy_file(path);
>  	if (size != check_size)
>  		die("error in size of file '%s'", path);
> -
> +out:
> +	put_tracing_file(path);
>  }
>  
>  static struct tracepoint_path *
> -- 
> 1.6.3
> 

