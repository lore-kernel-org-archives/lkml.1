Return-Path: <linux-kernel-owner+w=401wt.eu-S966253AbXEGS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253AbXEGS5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966239AbXEGS5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:57:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966224AbXEGS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:57:30 -0400
Date: Mon, 7 May 2007 11:55:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Stezenbach <js@linuxtv.org>
cc: Esben Nielsen <nielsen.esben@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070507183931.GB3472@linuxtv.org>
Message-ID: <alpine.LFD.0.98.0705071150370.3802@woody.linux-foundation.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
 <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
 <20070507183931.GB3472@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Johannes Stezenbach wrote:
> 
> One baffling example where gcc rewrites code is when
> conditionals depend on signed integer overflow:

Yes. This is one of my favourite beefs with gcc. Some of the optimization 
decisions seem to make no sense.

Your example is a good one, but my private beef has been in alias 
handling. Alias analysis is an important part of optimization, and there's 
two kinds: the static (and exact, aka "safe") kind that you can do 
regardless of any language definitions, because you *know* that you aren't 
actually changing behaviour, and the additional type-based heuristics that 
the C language allows.

So which ones would you expect a compiler to consider more important?

And which one do you think gcc will use?

Right. You can have static analysis that *guarantees* that two objects 
alias, but if gcc determins that they have different types and thus might 
not alias, it decides to use the heuristic instead of the firm knowledge, 
and generate code that doesn't work.

"Because the language definition allows it".

Oh well.

		Linus
