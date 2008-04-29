Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYD2R7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYD2R7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYD2R7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:59:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYD2R7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:59:19 -0400
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <e2e108260804291045k353e2ed0r4b14ba4820f6f156@mail.gmail.com>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
	 <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
	 <1209485739.13978.96.camel@twins>
	 <e2e108260804290929l3c7a6a07nddc18512abb9e6ed@mail.gmail.com>
	 <1209488643.6433.14.camel@lappy>
	 <e2e108260804291045k353e2ed0r4b14ba4820f6f156@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 19:58:32 +0200
Message-Id: <1209491912.6433.36.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 19:45 +0200, Bart Van Assche wrote:

> Let's return to the starting point of this discussion. The patch at
> the start of this thread forbids to invert the lock order of reader
> locks. Why to forbid this if it can't trigger a deadlock ? At least in
> user space code, it's quite easy to trigger such inversion. In
> sufficiently complex code where functions call other functions while
> holding a reader lock, reader lock inversion can be hard to avoid.

Sure, but the whole point is: lockdep cannot track those rules. _that_
is why I'm choosing to forbid them.

Also, on Linux only rwlock_t allows reader recursion, and that lock type
really ought to die, all users should convert to RCU (if possible).

So I'm not thinking placing this restriction on kernel code is going to
be painful.

