Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZDINNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZDINNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbZDINNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:13:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbZDINNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:13:39 -0400
Date: Thu, 9 Apr 2009 10:13:10 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: pass the right pointer to kfree()
Message-ID: <20090409131310.GC24946@ghostprotocols.net>
References: <49DD694C.8020902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD694C.8020902@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 09, 2009 at 11:19:40AM +0800, Li Zefan escreveu:
> If passing a string with leading white spaces to strstrip(),
> the returned ptr != the original ptr.
> 
> This bug was introduced by me.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I hadn't noticed that strstrip was added, oops.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> ---
>  kernel/trace/blktrace.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index b32ff44..921ef5d 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1377,12 +1377,12 @@ static int blk_trace_str2mask(const char *str)
>  {
>  	int i;
>  	int mask = 0;
> -	char *s, *token;
> +	char *buf, *s, *token;
>  
> -	s = kstrdup(str, GFP_KERNEL);
> -	if (s == NULL)
> +	buf = kstrdup(str, GFP_KERNEL);
> +	if (buf == NULL)
>  		return -ENOMEM;
> -	s = strstrip(s);
> +	s = strstrip(buf);
>  
>  	while (1) {
>  		token = strsep(&s, ",");
> @@ -1403,7 +1403,7 @@ static int blk_trace_str2mask(const char *str)
>  			break;
>  		}
>  	}
> -	kfree(s);
> +	kfree(buf);
>  
>  	return mask;
>  }
> -- 
> 1.5.4.rc3
