Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZHYBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZHYBVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZHYBVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:21:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZHYBVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:21:42 -0400
Message-ID: <4A933C55.4090808@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 09:20:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Anirban Sinha <ASinha@zeugmasystems.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] : eliminate code duplication in kernel/tracepoint.c
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anirban Sinha wrote:
> Hi Ingo:
> 
> I was going through the kernel tracepoints work. It's really impressive.
> Congratulations! 
> 
> The following cleanup popped up immediately. May be you guys have
> noticed it already.
> 

Maybe, but no one else sent this patch. ;)

> Cheers,
> 
> Ani
> 
> 
>>From 2068b87b9635a66e5e86b8ff4182d96a6e969584 Mon Sep 17 00:00:00 2001
> From: Anirban Sinha <asinha@zeugmasystems.com>
> Date: Mon, 24 Aug 2009 15:52:20 -0700
> Subject: Cleanup: eliminate code duplication in kernel/tracepoint.c
> 
> 
> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/tracepoint.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 1ef5d3a..4840ab6 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -554,9 +554,6 @@ int tracepoint_module_notify(struct notifier_block
> *self,
> 
>         switch (val) {
>         case MODULE_STATE_COMING:
> -               tracepoint_update_probe_range(mod->tracepoints,
> -                       mod->tracepoints + mod->num_tracepoints);
> -               break;
>         case MODULE_STATE_GOING:
>                 tracepoint_update_probe_range(mod->tracepoints,
>                         mod->tracepoints + mod->num_tracepoints);
> --
> 1.6.4
> 
> 
>>From 5e09b156be90b936db9c1977abcc04b5cbb4bd4a Mon Sep 17 00:00:00 2001
> From: Anirban Sinha <asinha@zeugmasystems.com>
> Date: Mon, 24 Aug 2009 15:55:12 -0700
> Subject: cleanup: remove redundant break statement.
> 

Oh, you should send 2 mails, one mail per patch.

But removing the break won't gain us anything. Actually It's
better to reserve the break.

> 
> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
> ---
>  kernel/tracepoint.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 4840ab6..35eed9c 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -557,7 +557,6 @@ int tracepoint_module_notify(struct notifier_block
> *self,
>         case MODULE_STATE_GOING:
>                 tracepoint_update_probe_range(mod->tracepoints,
>                         mod->tracepoints + mod->num_tracepoints);
> -               break;
>         }
>         return 0;
>  }
> --
> 1.6.4
> 
