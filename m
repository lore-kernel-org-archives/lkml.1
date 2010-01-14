Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483Ab0ANE5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0ANE5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 23:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698Ab0ANE5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 23:57:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0ANE5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 23:57:50 -0500
Message-ID: <4B4EA4F3.6090401@redhat.com>
Date: Thu, 14 Jan 2010 00:00:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [resend][PATCH 1/2] kprobetrace,doc: shell need single quote
 to use $ character
References: <20100114111032.D720.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100114111032.D720.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> shell interpret $val is as shell variable. thus we need quote if
> we use echo command.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Hi Ingo and KOSAKI-san,

Sorry, now this patch conflicts with my patch(commit 1464010) on the
latest -tip tree. The patch drops $argN support, so I updated the
1st example command.

Thank you,

> ---
>  Documentation/trace/kprobetrace.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index 47aabee..2be6e19 100644
> --- a/Documentation/trace/kprobetrace.txt
> +++ b/Documentation/trace/kprobetrace.txt
> @@ -82,13 +82,13 @@ Usage examples
>  To add a probe as a new event, write a new definition to kprobe_events
>  as below.
>  
> -  echo p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3 > /sys/kernel/debug/tracing/kprobe_events
> +  echo 'p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3' > /sys/kernel/debug/tracing/kprobe_events
>  
>   This sets a kprobe on the top of do_sys_open() function with recording
>  1st to 4th arguments as "myprobe" event. As this example shows, users can
>  choose more familiar names for each arguments.
>  
> -  echo r:myretprobe do_sys_open $retval >> /sys/kernel/debug/tracing/kprobe_events
> +  echo 'r:myretprobe do_sys_open $retval' >> /sys/kernel/debug/tracing/kprobe_events
>  
>   This sets a kretprobe on the return point of do_sys_open() function with
>  recording return value as "myretprobe" event.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

