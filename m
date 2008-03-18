Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYCRHSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYCRHSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYCRHR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:17:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYCRHRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:17:55 -0400
Date: Tue, 18 Mar 2008 00:17:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc5-mm1][regression?] BUG: spinlock wrong CPU, modprobe
Message-Id: <20080318001720.9b6aea83.akpm@linux-foundation.org>
In-Reply-To: <20080317120848.7B3F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080317120848.7B3F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 13:25:26 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> I found strange message at 2.6.25-rc5-mm1 booting.
> and it is always reproduce.
> 
> 
> and, Eric Piel's spinlock related patch(below URL) can't fixed my problem.
> http://marc.info/?l=linux-kernel&m=120561027011749&w=2
> 
> Is this known bug?
> or should i do bisect?
> 
> 
> 
> -------------------------------------------------------------------
> BUG: spinlock wrong CPU on CPU#3, udevd/2495
>  lock: a040000058246510, .magic: dead4ead, .owner: udevd/2495, .owner_cpu: 2
> 
> Call Trace:
>  [<a000000100015f00>] show_stack+0x80/0xa0
>                                 sp=e00001609262fbd0 bsp=e000016092620fd8
>  [<a000000100015f50>] dump_stack+0x30/0x60
>                                 sp=e00001609262fda0 bsp=e000016092620fc0
>  [<a0000001004674a0>] spin_bug+0x1a0/0x1c0
>                                 sp=e00001609262fda0 bsp=e000016092620f90
>  [<a000000100467590>] _raw_spin_unlock+0xd0/0x120
>                                 sp=e00001609262fda0 bsp=e000016092620f60
>  [<a00000010082bfe0>] _spin_unlock+0x20/0x40
>                                 sp=e00001609262fda0 bsp=e000016092620f40
>  [<a000000100138100>] do_wp_page+0x500/0xfe0
>                                 sp=e00001609262fda0 bsp=e000016092620ed8
>  [<a00000010013c560>] handle_mm_fault+0xe80/0x10e0
>                                 sp=e00001609262fda0 bsp=e000016092620e50
>  [<a00000010006c140>] ia64_do_page_fault+0x600/0xa40
>                                 sp=e00001609262fda0 bsp=e000016092620df0
>  [<a00000010000abe0>] ia64_leave_kernel+0x0/0x270
>                                 sp=e00001609262fe30 bsp=e000016092620df0
> 

I'm unaware of any other reports of anything like this so yes, please do
bisect it if you have the time.

