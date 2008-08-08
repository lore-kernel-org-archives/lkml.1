Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYHHORw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYHHORw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYHHORo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:17:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYHHORo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:17:44 -0400
Date: Fri, 8 Aug 2008 10:17:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>, rostedt@goodmis.org
Subject: Re: [PATCH -v2 7/8] kexec jump: ftrace_enabled_save/restore
Message-ID: <20080808141700.GF3840@redhat.com>
References: <1218178368.22039.80.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218178368.22039.80.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 02:52:48PM +0800, Huang Ying wrote:
> Add ftrace_enabled_save/restore, used to disable ftrace for a
> while. This is used by kexec jump.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 


CCing Steven Rostedt for ftrace related changes.

> ---
>  include/linux/ftrace.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -98,6 +98,24 @@ static inline void tracer_disable(void)
>  #endif
>  }
>  
> +static inline int ftrace_enabled_save(void)
> +{
> +#ifdef CONFIG_FTRACE
> +	int saved_ftrace_enabled = ftrace_enabled;
> +	ftrace_enabled = 0;
> +	return saved_ftrace_enabled;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline void ftrace_enabled_restore(int enabled)
> +{
> +#ifdef CONFIG_FTRACE
> +	ftrace_enabled = enabled;
> +#endif
> +}
> +
>  #ifdef CONFIG_FRAME_POINTER
>  /* TODO: need to fix this for ARM */
>  # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> 

