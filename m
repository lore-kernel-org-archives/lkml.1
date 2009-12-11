Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbZLKMCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbZLKMCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZLKMCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:02:18 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:64981 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZLKMCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I5TvUnvaE2FAXq1HdYOU8/Jn2HFGbjnnuIro5XFaUD474olkV/W0GjN8RDcTDmc/Cp
         HfIAhNgXEVf+BaddbI82SgGSeQ0IPAntccv8ZH8ZjZ6r0ydbN+t3Ke7XBVVHjp0Y0/RU
         H/JoQnzoKG8krl7ZOEd8HtPBfK0blvo+dPyu0=
Date: Fri, 11 Dec 2009 13:02:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/filters: Fix MATCH_FRONT_ONLY filter
	matching
Message-ID: <20091211120218.GD5244@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com> <4B221800.1050504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B221800.1050504@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:59:28PM +0800, Li Zefan wrote:
> MATCH_FRONT_ONLY matching works exactly as MATCH_FULL.
> 
> We should pass the length of the pattern to strncmp().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_filter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index c8eb1c0..bd492ce 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -262,7 +262,7 @@ static int regex_match_full(char *str, struct regex *r, int len)
>  
>  static int regex_match_front(char *str, struct regex *r, int len)
>  {
> -	if (strncmp(str, r->pattern, len) == 0)
> +	if (strncmp(str, r->pattern, r->len) == 0)
>  		return 1;
>  	return 0;
>  }


But it was working before the fix to match full.
The MATCH_FULL fix is nice but it also brings a new bug that
is fixed in this patch.

Could you perhaps rework the MATCH_FULL fix to avoid that?

Thanks.

