Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZARE6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZARE6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZARE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:58:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:43648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZARE6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:58:10 -0500
Message-ID: <4972B6D9.4080101@kernel.org>
Date: Sun, 18 Jan 2009 13:58:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-3-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 04:57:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Brian Gerst wrote:
> @@ -211,15 +211,13 @@ ENTRY(secondary_startup_64)
>  	 * data area.  Computing this requires two symbols - __per_cpu_load
>  	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
>  	 * it by hand.  As early_gdt_descr is manipulated by C code for
> -	 * secondary CPUs, this should be done only once for the boot CPU
> -	 * when early_gdt_descr_base contains zero.
> +	 * secondary CPUs, this should be done only once for the boot CPU.
>  	 */

It would probably be nice to mention that it's calculating per cpu
load addresses for early access.  The comment only refers to gdt_page
which is a bit misleading as it now also adjusts irqstackptr.

Also, as pda field name, irqstackptr might be fine but wouldn't it be
better to rename it to at least irq_stack_ptr as this change requires
touching every users anyway?

Thanks.

-- 
tejun
