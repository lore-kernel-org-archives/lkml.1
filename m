Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYKMW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYKMW7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYKMW7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:59:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbYKMW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:59:13 -0500
Date: Thu, 13 Nov 2008 14:58:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Message-Id: <20081113145846.bef2bb90.akpm@linux-foundation.org>
In-Reply-To: <491CAD20.9020202@kernel.org>
References: <491434FB.2050904@kernel.org>
	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	<20081110094033.GL22392@elte.hu>
	<20081110015511.453a801e.akpm@linux-foundation.org>
	<4918065A.6050402@kernel.org>
	<20081110100329.GA19970@elte.hu>
	<491A9F87.8040403@kernel.org>
	<20081112120814.GG11352@elte.hu>
	<491C8B38.9060901@kernel.org>
	<20081113131850.d94fb229.akpm@linux-foundation.org>
	<86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
	<20081113141340.7e17bdca.akpm@linux-foundation.org>
	<491CAD20.9020202@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 14:41:36 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Andrew Morton wrote:
> 
> >> ...
> >>
> >>>> +static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> >>> Do these need to be 32-bit?  Maybe they'll fit in 16-bit, dunno.
> >>>
> >> struct irq_desc {
> >>         unsigned int            irq;
> >> #ifdef CONFIG_SPARSE_IRQ
> >>         struct list_head        list;
> >>         struct list_head        hash_entry;
> >>         struct timer_rand_state *timer_rand_state;
> >>         unsigned int            *kstat_irqs;
> > 
> > That doesn't address my question.
> > 
> > The above array can be very large.  Can we halve its size by using
> > 16-bit quantities?  Will this code ever encounter IRQ numbers larger
> > than 65536?
> > 
> 
> NR_CPUS=4096, NR_IRQS_LEGACY=16, and that array will be 256k bytes
> 
> later could change that alloc_bootmem, so NR_CPUS will be replaced to nr_cpu_ids

Do the entries in that array need to be 32-bit?
