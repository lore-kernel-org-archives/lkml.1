Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZILPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZILPRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZILPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:17:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:35835 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZILPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:17:17 -0400
Message-ID: <4AABBB41.40208@windriver.com>
Date: Sat, 12 Sep 2009 10:16:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kgdb: Replace strstr() by strchr() for single-character
 needles
References: <alpine.DEB.2.00.0909112214370.15464@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.0909112214370.15464@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2009 15:16:18.0785 (UTC) FILETIME=[FA7C9510:01CA33BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the patch is fine and I will accept it into the kgdb tree for
pushing to Linus, but I did have a question.

How did the kgdbts.o end up getting compiled on m68k if there is no kgdb
support on m68k?

CONFIG_KGDB_TESTS should not be able to be set if there is no
CONFIG_KGDB set.

Thanks,
Jason.


Geert Uytterhoeven wrote:
> Some versions of gcc replace calls to strstr() with single-character
> "needle" string parameters by calls to strchr() behind our back.
> This causes linking errors if strchr() is defined as an inline function
> in <asm/string.h> (e.g. on m68k, which BTW doesn't have kgdb support).
>
> Prevent this by explicitly calling strchr() instead.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This is the single remaining case where strstr() is used with a
> single-character needle.  Cfr.
> commit 0d03d59d9b31cd1e33b7e46a80b6fef66244b1f2 ("md: Fix "strchr"
> [drivers/md/dm-log-userspace.ko] undefined!")
> commit d8b0fb51ef1563c631d26cb649a5479b5cc4899c ("[PATCH] libertas link error
> due to gcc `smartness'")
>
>  drivers/misc/kgdbts.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index e4ff50b..2a43d8c 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -885,16 +885,16 @@ static void kgdbts_run_tests(void)
>  	int nmi_sleep = 0;
>  	int i;
>  
> -	ptr = strstr(config, "F");
> +	ptr = strchr(config, 'F');
>  	if (ptr)
>  		fork_test = simple_strtol(ptr + 1, NULL, 10);
> -	ptr = strstr(config, "S");
> +	ptr = strchr(config, 'S');
>  	if (ptr)
>  		do_sys_open_test = simple_strtol(ptr + 1, NULL, 10);
> -	ptr = strstr(config, "N");
> +	ptr = strchr(config, 'N');
>  	if (ptr)
>  		nmi_sleep = simple_strtol(ptr+1, NULL, 10);
> -	ptr = strstr(config, "I");
> +	ptr = strchr(config, 'I');
>  	if (ptr)
>  		sstep_test = simple_strtol(ptr+1, NULL, 10);
>  
>   

