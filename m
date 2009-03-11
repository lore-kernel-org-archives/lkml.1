Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZCKBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZCKBSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZCKBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:18:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54127 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZCKBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:18:08 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] proc: fix kflags to uflags copying in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090311010004.GA8237@localhost>
References: <20090311010004.GA8237@localhost>
Message-Id: <20090311101612.A7FD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 11 Mar 2009 10:17:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix kpf_copy_bit(src,dst) to be kpf_copy_bit(dst,src) to match the
> actual call patterns, e.g. kpf_copy_bit(kflags, KPF_LOCKED, PG_locked).
> 
> This misplacement of src/dst only affected reporting of PG_writeback,
> PG_reclaim and PG_buddy. For others kflags==uflags so not affected.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> 
> This is a tested and trivial no-side-effect fix.
> I'd suggest it for 2.6.29-rc7 and 2.6.28.X kernels.
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 2d13451..e998383 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -80,7 +80,7 @@ static const struct file_operations proc_kpagecount_operations = {
>  #define KPF_RECLAIM    9
>  #define KPF_BUDDY     10
>  
> -#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
> +#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)

Good catch! :)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


but don't worry. the number of this interface user is very few.



