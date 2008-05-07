Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbYEGI2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbYEGI2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYEGI2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:28:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56590 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYEGI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:28:27 -0400
Message-ID: <482167DF.4020200@cn.fujitsu.com>
Date: Wed, 07 May 2008 16:27:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Shen Feng <shen@cn.fujitsu.com>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] x86: remove printk compiling warning
References: <482162E5.7030606@cn.fujitsu.com>
In-Reply-To: <482162E5.7030606@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Randy Dunlap <rdunlap@xenotime.net>

Shen Feng wrote:
> Since size is unsigned long, the format string is changed
> from zd to lu.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  arch/x86/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index cc6f5eb..c0c68c1 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
> 
>  	/* Copy section for each CPU (we discard the original) */
>  	size = PERCPU_ENOUGH_ROOM;
> -	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
> +	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
>  			  size);
> 
>  	for_each_possible_cpu(i) {

Let me figure out this.

Commit 0fc5035fc66d26776bebd45c508a9bce3611f388 in linux-next changed
'size' from unsigned long to ssize_t, causing a compile warning, and
then Randy posted a patch to fix it:
	http://marc.info/?l=linux-kernel&m=120958902125650&w=2

But this patch was wrongly merged into mainline, causing the compile warning
you described here.

So we should revert Randy's patch and re-apply it to linux-next ?

