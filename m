Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZHQBbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZHQBbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZHQBbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:31:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52343
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbZHQBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:31:23 -0400
Date: Sun, 16 Aug 2009 18:31:34 -0700 (PDT)
Message-Id: <20090816.183134.90977928.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090806070242.GF12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk>
	<20090802.131705.81498579.davem@davemloft.net>
	<20090806070242.GF12579@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 6 Aug 2009 09:02:42 +0200

> On Sun, Aug 02 2009, David Miller wrote:
>> From: Jens Axboe <jens.axboe@oracle.com>
>> Date: Wed, 29 Jul 2009 13:25:10 +0200
>> 
>> > -#define NR_SYSCALLS		327
>> > +#define NR_SYSCALLS		328
>> 
>> When you increase this value, you have to add entries to all of the
>> syscall tables.  The syscall dispatch checks against this as a limit,
>> so if you don't explicitly add an entry to all the tables, it's
>> possible to deref garbage past the end of the table and try to jump to
>> it as a syscall.
> 
> Oops, missed the 32-bit table. Does the below look better?

You got the native 32-bit table, and the native 64-bit table,
but you missed sparc64's 32-bit compat syscall table :-)

There are two syscall tables in arch/sparc/systbls.S, you only
got the native 64-bit one.

Please fix this up, and the patch is fine with that cured,
so make it a formal submission with commit message and signoffs
thanks!

> I'm assuming that this will happen automatically at some point, instead
> of perf defaulting to building with the same 32/64-bit of the kernel.

Right, it looks like Ingo and co. are going to take care of that.
