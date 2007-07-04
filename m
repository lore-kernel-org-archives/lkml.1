Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXGDLQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXGDLQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbXGDLQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:16:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:33931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbXGDLQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:16:30 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Keith Packard <keith.packard@intel.com>
Subject: Re: [patch] CFS scheduler, -v18
References: <20070622220202.GA16872@elte.hu>
	<19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	<b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
	<19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
	<20070702155029.GA13241@elte.hu>
	<19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
	<1183446743.7070.14.camel@Homer.simpson.net>
	<20070703072252.GB29984@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Jul 2007 14:11:54 +0200
In-Reply-To: <20070703072252.GB29984@elte.hu>
Message-ID: <p73odis2ws5.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> ah. That indeed makes sense. It seems like the xterm doesnt process the 
> Ctrl-C/Z keypresses _at all_ when it is 'spammed' with output. Normally, 
> output 'spam' is throttled by the scroll buffer's overhead. But in 
> Vegard's case, the printout involves a \r carriage return:
> 
>        printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);
> 
> which allows xterm-spam (attached) to easily flood the xterm (without 
> any scrolling that would act as a throttle) and the xterm to flood Xorg. 
> 
> I suspect we need the help of an xterm/Xorg expert? (maybe Keith can 
> give us further pointers? I can reproduce the problem on a T60 with i940 
> and Core2Duo running Fedora 7 + Xorg 7.1.)

Xorg seems to have a couple of starvation issues. e.g. I found
the Gantt view in icemon during a busy compile session can starve all
other X clients for tenths of seconds.

-Andi
