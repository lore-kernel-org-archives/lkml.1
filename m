Return-Path: <linux-kernel-owner+w=401wt.eu-S934924AbXGQQHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934924AbXGQQHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbXGQQHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:07:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbXGQQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:07:03 -0400
Date: Tue, 17 Jul 2007 09:05:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Chuck Ebbert <76306.1226@compuserve.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: a bogus set_fs(USER_DS) in setup_frame/setup_rt_frame ?
In-Reply-To: <20070717154638.GA342@tv-sign.ru>
Message-ID: <alpine.LFD.0.999.0707170902570.19166@woody.linux-foundation.org>
References: <20070717154638.GA342@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Oleg Nesterov wrote:
>
> I am really puzzled by set_fs(USER_DS) in setup_frame/setup_rt_frame.
> 
> How is it possible that current->addr_limit != USER_DS ? If this _is_
> possible, how can can we trust the result of access_ok() above?

Heh. I think it's entirely historical.

Please realize that the whole reason that function is called "set_fs()" is 
that it literally used to set the %fs segment register, not 
"->addr_limit".

So I think the "set_fs(USER_DS)" is there _only_ to match the other

        regs->xds = __USER_DS;
        regs->xes = __USER_DS;
        regs->xss = __USER_DS;
        regs->xcs = __USER_CS;

things, and never mattered. And now it matters even less, and has been 
copied to all other architectures where it is just totally insane.

		Linus
