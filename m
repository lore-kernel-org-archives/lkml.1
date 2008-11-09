Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYKIUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYKIUzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYKIUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:55:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbYKIUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:55:46 -0500
Date: Sun, 9 Nov 2008 12:55:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-Id: <20081109125522.b5266352.akpm@linux-foundation.org>
In-Reply-To: <20081109213811.4b85adc6@neptune.home>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
	<20081109122515.1deb9ec2@infradead.org>
	<20081109213811.4b85adc6@neptune.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 21:38:11 +0100 Bruno Pr__mont <bonbons@linux-vserver.org> wrote:

> On Sun, 09 November 2008 Arjan van de Ven wrote:
> > On Sun, 9 Nov 2008 Andrew Morton wrote:
> > > On Sun, 9 Nov 2008 Bruno Pr__mont wrote:
> > > 
> > > > The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE
> > > > bits; CURSOR_SIZE is defined as (8 * 1024). Using up twice 1k on
> > > > stack is too much for 4k-stack (though it works with 8k-stacks).
> > > 
> > > >  
> > > >  	if (viacursor.enable)
> > > 
> > > Is the ->fb_cursor handler allowed to perform GFP_KERNEL memory
> > > allocations?  It's never called from atomic contexts?
> > 
> > if it's allowed to do GFP_KERNEL memory allocations the statement that
> > it works with 8k stacks is a bit overstated... since irq's can come in
> > and take several KB of stack as well ;)
> I don't know if it can be called from atomic contexts or not :(
> 
> 
> In addition I get panics some time after start-up which I'm not sure
> what to associate them with (apparently unrelated)
> It could be some stack overflow by calling fbset (I will to more testing
> in order to find out)
> 
> First attempt: calling fbset via ssh:
> 
> [ 1806.952151] BUG: unable to handle kernel NULL pointer dereference at 00000123
> [ 1806.952601] IP: [<c03d2737>] icmpv6_send+0x387/0x580
> 
> ...
>
> Second attempt, delayed after calling fbset from console:
> 
> [  217.260426] BUG: unable to handle kernel NULL pointer dereference at 000000c7
> [  217.260915] IP: [<c0380b46>] rt_worker_func+0xb6/0x160

gack.  Your kernel was destroyed.

Stack overflow might well explain this.  Does it work OK with 8k stacks?

scripts/checkstack.pl should help find the problems.
