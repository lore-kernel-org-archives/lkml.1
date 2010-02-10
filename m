Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0BJW1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:27:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab0BJW1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:27:03 -0500
Message-ID: <4B73329F.4050406@redhat.com>
Date: Wed, 10 Feb 2010 17:26:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/kprobes: fix probe parsing
References: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Trying to add a probe like
> 
> echo p:myprobe 0x10000 > /sys/kernel/debug/tracing/kprobe_events
> 
> will fail since the wrong pointer is passed to strict_strtoul
> when trying to convert the address to an unsigned long.

Right, it's a bug! Thank you!


> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  kernel/trace/trace_kprobe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -689,7 +689,7 @@ static int create_trace_probe(int argc, 
>  			return -EINVAL;
>  		}
>  		/* an address specified */
> -		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
> +		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
>  		if (ret) {
>  			pr_info("Failed to parse address.\n");
>  			return ret;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

