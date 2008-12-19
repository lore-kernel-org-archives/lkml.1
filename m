Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYLSILd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYLSILd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYLSILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:11:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbYLSILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:11:24 -0500
Date: Fri, 19 Dec 2008 00:11:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Magnus Damm" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] clocksource: pass clocksource to read() callback
Message-Id: <20081219001121.bf985802.akpm@linux-foundation.org>
In-Reply-To: <20081218234725.4126d858.akpm@linux-foundation.org>
References: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
	<20081217175658.0706a07f.akpm@linux-foundation.org>
	<aec7e5c30812182330u6e907867i971396923c167ddf@mail.gmail.com>
	<20081218234725.4126d858.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 23:47:25 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Dec 2008 16:30:36 +0900 "Magnus Damm" <magnus.damm@gmail.com> wrote:
> 
> > >  CHK     include/linux/version.h
> > >  CHK     include/linux/utsrelease.h
> > >  SYMLINK include/asm -> include/asm-sparc
> > >  CC      arch/sparc/kernel/asm-offsets.s
> > > In file included from include/linux/ktime.h:25,
> > >                 from include/linux/timer.h:5,
> > >                 from include/linux/clocksource.h:16,
> > >                 from /usr/src/devel/arch/sparc/include/asm/timer_64.h:11,
> > >                 from /usr/src/devel/arch/sparc/include/asm/timer.h:4,
> > >                 from /usr/src/devel/arch/sparc/include/asm/timex_64.h:9,
> > >                 from /usr/src/devel/arch/sparc/include/asm/timex.h:4,
> > >                 from include/linux/timex.h:170,
> > >                 from include/linux/sched.h:54,
> > >                 from arch/sparc/kernel/asm-offsets.c:13:
> > > include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
> > [lot's of warning snipped]
> > 
> > How about the (unfortunately most likely mangled) patch below? Does it
> > help?
> 
> yup.

It still blows up though.  Any call to get_cycles() goes:

crypto/tcrypt.c: In function `test_cipher_cycles':
crypto/tcrypt.c:107: error: too few arguments to function
crypto/tcrypt.c:112: error: too few arguments to function
crypto/tcrypt.c: In function `test_hash_cycles_digest':
crypto/tcrypt.c:305: error: too few arguments to function
crypto/tcrypt.c:311: error: too few arguments to function
crypto/tcrypt.c: In function `test_hash_cycles':
crypto/tcrypt.c:361: error: too few arguments to function
crypto/tcrypt.c:375: error: too few arguments to function

because this:

arch/sparc/include/asm/timex_64.h:#define get_cycles()  tick_ops->get_tick()

needs help.
