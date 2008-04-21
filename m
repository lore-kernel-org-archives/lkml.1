Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYDUJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYDUJz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYDUJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:55:16 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:57037 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbYDUJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:55:15 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <20080419142329.GA5339@elte.hu>
	<20080420121803.GK1595@cs181133002.pp.htv.fi>
	<480B4DB4.8070107@sandeen.net>
	<200804210945.24479.vda.linux@googlemail.com>
Date: Mon, 21 Apr 2008 11:55:13 +0200
In-Reply-To: <200804210945.24479.vda.linux@googlemail.com> (Denys Vlasenko's message of "Mon, 21 Apr 2008 09:45:24 +0200")
Message-ID: <8763ub8rcu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 09:48:24.0611 (UTC) FILETIME=[D7811F30:01C8A394]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:
>
> Forget about 50k threads. 4k of waste per process is a waste nevertheless.
> It's not at all unusual to have 250+ processes, and 250 processes with 8k
> stack each waste 1M. Do you think extra 1M won't be useful to have?

If the 1M gives you more reliability (and I think it does) I don't 
think it is "wasted". Would you trade occasional crashes for 1MB? 
I wouldn't.

Also a typical process uses much more memory than just 4K. If it's
not a thread it needs own page tables and from those alone you're
easily into 10+ pages even for a quite small process. But even threads
in practice have other overheads too if they actually do something.
The 4K won't save or break you.

[BTW if you're really interested in saving memory there are lots
of other subsystems where you could very likely save more. A common
example are the standard hash tables which are still too big]

The trends are also against it: kernel code is getting more and more
complex all the time with more and more complicated stacks of
different subsystems on top of each other. It wouldn't surprise me if
at some point 8KB isn't even enough anymore. Going into the
other direction is definitely the wrong way.

-Andi
