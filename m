Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbXJ0VWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbXJ0VWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXJ0VWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:22:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3013 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXJ0VWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:22:41 -0400
Date: Sat, 27 Oct 2007 23:22:31 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: torvalds@osdl.org, akpm@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <20071027201429.GE9816@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0710272319550.1817@scrub.home>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0710272114590.1818@scrub.home> <20071027201429.GE9816@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 28 Oct 2007, Alexey Dobriyan wrote:

> > If it's just about the type checking, something like below should pretty 
> > much do the same.
> 
> It won't catch, the following if both variables are unsigned long:
> 
> 	spin_lock_irqsave(&lock, flags);
> 		[stuff]
> 	spin_unlock_irqrestore(&lock, foo->flags);
> 
> It won't catch "static unsigned long flags;". With sparse, we can
> eventually mark type as "on-stack only".

It should be on the stack, but we have cases where a pointer to it is used 
(e.g. lock_timer_base). How do you want to deal with this?

bye, Roman
