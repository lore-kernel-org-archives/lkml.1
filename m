Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZGEA2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZGEA2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 20:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZGEA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 20:28:48 -0400
Received: from ozlabs.org ([203.10.76.45]:44063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZGEA2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 20:28:48 -0400
Date: Sun, 5 Jul 2009 10:25:36 +1000
From: Anton Blanchard <anton@samba.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090705002536.GA28060@kryten>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <20090625093346.GD23547@elte.hu> <1245934522.5308.39.camel@hpdv5.satnam> <ada3a9ol58t.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3a9ol58t.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> IMHO "L1d" is too abbreviated for it to be obvious that it means L1 data
> cache.  If you want something really short maybe "L1-d$" might be a
> little clearer, but I stil like "L1-dcache" best.

There's one problem with L1-d$-* for event names. It took me a few goes
before I realised I was being hit by bash variable expansion:


#  perf stat -e L1-d$-loads ls

 usage: perf stat [<options>] <command>

...


# perf stat -e 'L1-d$-loads' ls

 Performance counter stats for 'ls':

        1273291  L1-d$-loads             

    0.004434037  seconds time elapsed


I also prefer the more verbose L1-dcache-* names, and since we support
aliases its mostly a matter of screen real estate when printing out the
statistics.

Anton
