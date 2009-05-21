Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbZEUX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbZEUX0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZEUX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:26:23 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:19931 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZEUX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:26:22 -0400
Message-ID: <4A15E36E.9080501@oracle.com>
Date: Thu, 21 May 2009 16:27:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
References: <cover.1242943463.git.joe@perches.com> <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
In-Reply-To: <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A15E2D9.0001:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Add a DO_ONCE statement expression analogous to printk_once
> that executes any arbitrary statement exactly once.
> 
> This will take the place of printk_once so that
> DO_ONCE(pr_<foo>) or any other statement performed
> a single time may be easily written.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/kernel.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 883cd44..a5520c9 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -637,6 +637,18 @@ static inline void ftrace_dump(void) { }
>  #define swap(a, b) \
>  	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>  
> +/*
> + * Do something once (analogous to WARN_ONCE() et al):
> + */
> +#define DO_ONCE(x...) ({			\
> +	static bool __done = false;		\
> +						\
> +	if (!__done) {				\
> +		x;				\
> +		__done = true;			\

Hi Joe,

Since x is of arbitrary size & time duration, I think that x; should follow
		__done = true;
instead of being before it, as was done in printk_once().  Otherwise there
could be a sizable window there x could be done more than once.


> +	}					\
> +})
> +
>  /**
>   * container_of - cast a member of a structure out to the containing structure
>   * @ptr:	the pointer to the member.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
