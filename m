Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZLMBMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZLMBMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZLMBMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:12:32 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45121 "HELO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754031AbZLMBMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:12:30 -0500
Date: Sun, 13 Dec 2009 00:34:54 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] irq: handle irq0 special only on x86
In-Reply-To: <4B21246B.4070804@zytor.com>
Message-ID: <alpine.LFD.2.00.0912130022090.14955@eddie.linux-mips.org>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com> <20091209.014151.140337246.davem@davemloft.net> <20091210082452.GA2420@pengutronix.de> <4B21246B.4070804@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, H. Peter Anvin wrote:

> > Note, I fully agree to use 0 for NO_IRQ if you have an int-sized value
> > that holds either NO_IRQ or a valid irq number.  But in practise I'd not
> > recommend to use this idiom.
> > 
> 
> You're tilting at windmills about something that was settled long ago,
> like it or not.

 This is nothing that couldn't be changed; my personal preference would be 
quite the obvious choice of something along the lines of:

#define NO_IRQ -1U

that would also have the benefit of forcing all the relevant places to use 
the macro rather than an expression like !irq, improving code readability 
and greppability.

 My motivation to push any such change at the moment is rather weak though 
-- it's been a while since I was last pissed off by the weirdness of 
assumptions about IRQ 0 in Linux.

  Maciej
