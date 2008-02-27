Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYB0HsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYB0HsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYB0HsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:48:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYB0HsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:48:17 -0500
Message-ID: <47C51566.1070104@cn.fujitsu.com>
Date: Wed, 27 Feb 2008 15:46:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] cpuset: fix return value of cpuset_populate()
References: <47C5131A.80508@cn.fujitsu.com> <20080227014135.0c361ab3.pj@sgi.com>
In-Reply-To: <20080227014135.0c361ab3.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> [Resending a patch that Li Zefan just sent, adding the other Paul (Menage)
>  to the CC list.  -pj]
> 

Thanks, I should have CCed Menage. :)

> - no need to check err == 0
> - the last return value of cgroup_add_file() is ignored
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cpuset.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3e296ed..1c5b2d2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1482,10 +1482,10 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
>  	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
>  		return err;
>  	/* memory_pressure_enabled is in root cpuset only */
> -	if (err == 0 && !cont->parent)
> +	if (!cont->parent)
>  		err = cgroup_add_file(cont, ss,
>  					 &cft_memory_pressure_enabled);
> -	return 0;
> +	return err;
>  }
>  
>  /*
