Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZHYF14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZHYF14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZHYF1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:27:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52592 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbZHYF1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:27:54 -0400
Message-ID: <4A93760C.4020107@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 13:26:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Anirban Sinha <ASinha@zeugmasystems.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] : eliminate code duplication in kernel/tracepoint.c
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local> <4A933C55.4090808@cn.fujitsu.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA902E@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA902E@exchange.ZeugmaSystems.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11:57, Anirban Sinha wrote:
> OK, here's the modified patch:
> 
>>From 52cea59801ac5b772c49ae995f4df1940a0d88fa Mon Sep 17 00:00:00 2001
> From: Anirban Sinha <asinha@zeugmasystems.com>
> Date: Mon, 24 Aug 2009 20:52:35 -0700
> Subject: cleanup: eliminate code duplication in kernel/tracepoint.c
> 
> 
> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
> ---
>  kernel/tracepoint.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 1ef5d3a..35eed9c 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -554,13 +554,9 @@ int tracepoint_module_notify(struct notifier_block
> *self,
>  
>  	switch (val) {
>  	case MODULE_STATE_COMING:
> -		tracepoint_update_probe_range(mod->tracepoints,
> -			mod->tracepoints + mod->num_tracepoints);
> -		break;
>  	case MODULE_STATE_GOING:
>  		tracepoint_update_probe_range(mod->tracepoints,
>  			mod->tracepoints + mod->num_tracepoints);
> -		break;

I still think it's better not to remove this break. every "case"
should have a break or a return, expect for the falling throught
cases.

>  	}
>  	return 0;
>  }

