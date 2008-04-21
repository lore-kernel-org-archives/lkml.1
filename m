Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbYDUS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbYDUS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbYDUS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:57:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61736 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565AbYDUS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:57:29 -0400
Date: Mon, 21 Apr 2008 14:57:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: fix kernel rodata NX setting
In-Reply-To: <20080421214824.0c5dc637@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804211455010.23157@gandalf.stny.rr.com>
References: <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal>
 <20080420000657.20ba6b4b@daedalus.pq.iki.fi> <20080420005208.12ad32fd@daedalus.pq.iki.fi>
 <20080419215826.GC2831@Krystal> <20080420014206.5cd61d4a@daedalus.pq.iki.fi>
 <20080420000509.GA7496@Krystal> <20080420101408.518b21b4@daedalus.pq.iki.fi>
 <20080420194440.GA15319@Krystal> <20080420231838.21eaf426@daedalus.pq.iki.fi>
 <20080420202533.GA16538@Krystal> <20080421214824.0c5dc637@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 21 Apr 2008, Pekka Paalanen wrote:

> From 35922163c8054bd8d12df78ebae6a6a603760206 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Mon, 21 Apr 2008 21:36:09 +0300
> Subject: [PATCH] x86_64: fix kernel rodata NX setting
>
> Without CONFIG_DYNAMIC_FTRACE, mark_rodata_ro() would mark a wrong
> number of pages as no-execute. The bug was introduced in the patch
> "ftrace: dont write protect kernel text". The symptom was machine reboot
> after a CPU hotplug.
>
> Signed-off-by: Pekka Paalanen <pq@iki.fi>

Good catch!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

>  arch/x86/mm/init_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 7851773..d7ae30a 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -792,7 +792,7 @@ void mark_rodata_ro(void)
>  	 * The rodata section (but not the kernel text!) should also be
>  	 * not-executable.
>  	 */
> -	set_memory_nx(rodata_start, (end - start) >> PAGE_SHIFT);
> +	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
>
>  	rodata_test();
>
> --
> 1.5.3.7
>
>
