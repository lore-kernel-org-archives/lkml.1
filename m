Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZIQI42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZIQI42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZIQI41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:56:27 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48612 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbZIQI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G843WGDIcinQ043DQe+c4nUqRShmBV/BPC82JQmSLgsC6oUPMPcazbu0NrzjRzuI+l
         jJTFJvYDk1Wxybn+uPi2xosdonp8u7pitcCQujMd4ddFby0pGZNA3tOzfbygP5P1gZZq
         As7lNpwg9dIXj+COKjEQTKXhs4TzjIJq/wYGg=
Date: Thu, 17 Sep 2009 10:56:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf trace: Sample timestamp and cpu when using record
	flag
Message-ID: <20090917085622.GA5184@nowhere>
References: <4AB1F827.8040905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB1F827.8040905@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:49:43PM +0800, Li Zefan wrote:
> Sample timestamp and cpu just like the -R option.
> 
> Before:
>             init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
>             init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
>             init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=1 handler=i8042
>             init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
>             init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=1 handler=i8042
> 
> After:
>             init-0     [001]  7364.568965353: irq_handler_entry: irq=18 handler=eth0
>             init-0     [001]  7365.530226877: irq_handler_entry: irq=1 handler=i8042
>             init-0     [001]  7365.542831563: irq_handler_entry: irq=18 handler=eth0
>             init-0     [001]  7365.644156299: irq_handler_entry: irq=18 handler=eth0
>             init-0     [001]  7365.694556201: irq_handler_entry: irq=18 handler=eth0
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  tools/perf/util/parse-events.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index c9ef944..2156269 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -425,8 +425,11 @@ parse_single_tracepoint_event(char *sys_name,
>  	int fd;
>  
>  	if (flags) {
> -		if (!strncmp(flags, "record", strlen(flags)))
> +		if (!strncmp(flags, "record", strlen(flags))) {
>  			attr->sample_type |= PERF_SAMPLE_RAW;
> +			attr->sample_type |= PERF_SAMPLE_TIME;
> +			attr->sample_type |= PERF_SAMPLE_CPU;
> +		}
>  	}
>  
>  	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
> -- 
> 1.6.3
> 

