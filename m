Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZHQV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZHQV60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHQV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:58:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZHQV6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:58:25 -0400
Date: Mon, 17 Aug 2009 23:58:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
	enabled
Message-ID: <20090817215808.GB15016@elte.hu>
References: <4A89BF90.5070202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89BF90.5070202@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix trace_skb_sources build when CONFIG_NET is not enabled:
> 
> kernel/built-in.o: In function `probe_skb_dequeue':
> trace_skb_sources.c:(.text+0xd9152): undefined reference to `init_net'
> trace_skb_sources.c:(.text+0xd9188): undefined reference to `dev_get_by_index'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> ---
>  kernel/trace/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090817.orig/kernel/trace/Kconfig
> +++ linux-next-20090817/kernel/trace/Kconfig
> @@ -236,6 +236,7 @@ config BOOT_TRACER
>  
>  config SKB_SOURCES_TRACER
>  	bool "Trace skb source information"
> +	depends on NET
>  	select GENERIC_TRACER
>  	help
>  	   This tracer helps developers/sysadmins correlate skb allocation and

Hm, there's nothing like this in the tracing tree.

Could we please move kernel/trace/* commits to the tracing tree, so 
that it gets adequate testing and review, etc?

	Ingo
