Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZINJHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZINJHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbZINJHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:07:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZINJHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:07:34 -0400
Date: Mon, 14 Sep 2009 11:07:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: gregkh <gregkh@suse.de>, LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [GIT BISECT -next] mem.c: could not login on console of fedora
 10
In-Reply-To: <4AADEA82.8000500@np.css.fujitsu.com>
Message-ID: <alpine.LNX.2.00.0909141106240.17028@wotan.suse.de>
References: <4AADEA82.8000500@np.css.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Jin Dongming wrote:

> When I build and boot -next on fedora 10, I can not login anymore.
> When I input the user name and password, the system does not output
> any message and requires user to input the user name and password
> again and again.
> 
> I find the patch which caused this problem with "GIT BISECT" command.
> And the patch is
>     commit 7c4b7daa1878972ed0137c95f23569124bd6e2b1
>     "mem_class: use minor as index instead of searching the array".
> 
> Though I don't know the real reason why user could not login, I
> confirmed the patch I made as following could resolve the problem on
> fedora 10.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  drivers/char/mem.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index bed3503..0491cdf 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -878,8 +878,8 @@ static const struct memdev {
>  	[ 4] = { "port", &port_fops, NULL },
>  #endif
>  	[ 5] = { "zero", &zero_fops, &zero_bdi },
> -	[ 6] = { "full", &full_fops, NULL },
> -	[ 7] = { "random", &random_fops, NULL },
> +	[ 7] = { "full", &full_fops, NULL },
> +	[ 8] = { "random", &random_fops, NULL },
>  	[ 9] = { "urandom", &urandom_fops, NULL },
>  	[11] = { "kmsg", &kmsg_fops, NULL },
>  #ifdef CONFIG_CRASH_DUMP
> -- 
> 1.6.2.2

I am not entirely sure why I have been CCed on this while the patch author 
hasn't :) Adding Kay to CC.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
