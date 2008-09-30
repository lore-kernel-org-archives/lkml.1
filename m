Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbYI3HPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbYI3HPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYI3HPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:15:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYI3HPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:15:34 -0400
Date: Tue, 30 Sep 2008 09:15:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: let marker_debug as module parameter
Message-ID: <20080930071520.GA2838@elte.hu>
References: <48E19CE8.8070006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E19CE8.8070006@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> if we want to enable marker debug output, we have to modify
> the code and remake/reinstall the kernel in current code.
> 
> this patch enable marker_debug to be set when kernel start.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 9f76c4a..5d8404f 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -28,8 +28,9 @@
>  extern struct marker __start___markers[];
>  extern struct marker __stop___markers[];
>  
> -/* Set to 1 to enable marker debug output */
> -static const int marker_debug;
> +static int marker_debug;
> +module_param(marker_debug, bool, 0);
> +MODULE_PARM_DESC(marker_debug, "Set to 1 to enable marker debug output");

hm, in tip/master we already have ftrace_printk(), which allows such 
debug output to any of the active tracers. That is a far more useful way 
of debugging such things. See:

  http://people.redhat.com/mingo/tip.git/README

and:

  http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt

note how much cleaner and more usable it will also become: no silly 
module flags or recompilation to activate this debug output, and no 
debug clutter in the syslog.

if you enable tracing in the 'nop' tracer then only the 
ftrace_printk()'s will be printed, no other trace entries.

	Ingo
