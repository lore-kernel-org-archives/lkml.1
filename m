Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYIHPYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYIHPYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYIHPYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:24:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:42558 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYIHPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hikUV8xSaExwqQCtK2eP396evWuqhn9XvkStAK1uspAvxIX7dxBUAbSKSYpcfEhMUb
         Wsynzm1CMZ1H35Qm0cyUzdVebsnqVwRmyi5abmC4fZ3drtPACU8VVnfGM3gXbpqEUszj
         VJZlSUhzBTlyJmbaft4gjQrot8NtrclQGIwz4=
Message-ID: <19f34abd0809080824k4dc5e4faq777f7fb3b5fe05fe@mail.gmail.com>
Date: Mon, 8 Sep 2008 17:24:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [GIT PULL] kmemcheck updates for tip/kmemcheck
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080908151753.GE10580@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080907200943.GA2665@localhost.localdomain>
	 <20080908151753.GE10580@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 5:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> yeah, merges should generally be done in the upstream repo. Obviously
> git-request-pull must list all the commits that happened - it doesnt
> know which commits are 'interesting' or not. I've done an upstream
> merge.
>
> btw., a small build fix (see below) was needed.

Oops. I was being enthusiastic and removed too much.

>
> ---------------->
> From 92a9abb2c571ab8fedaee3537c5667b4e61188ce Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 8 Sep 2008 16:50:43 +0200
> Subject: [PATCH] kmemcheck: build fix
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
>
> fix:
>
>  arch/x86/mm/kmemcheck/kmemcheck.c: In function 'kmemcheck_init':
>  arch/x86/mm/kmemcheck/kmemcheck.c:42: error: 'setup_max_cpus' undeclared (first use in this function)
>  arch/x86/mm/kmemcheck/kmemcheck.c:42: error: (Each undeclared identifier is reported only once
>  arch/x86/mm/kmemcheck/kmemcheck.c:42: error: for each function it appears in.)
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/kmemcheck/kmemcheck.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index eef8c6a..75831f0 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -35,6 +35,7 @@ void __init kmemcheck_init(void)
>  {
>        printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
>
> +#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)

Should really be just:

+#if defined(CONFIG_SMP)

Can you amend?

Thanks a lot,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
