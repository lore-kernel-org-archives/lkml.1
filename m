Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXJaG4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXJaG4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXJaG4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:56:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46078
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbXJaG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:56:01 -0400
Date: Tue, 30 Oct 2007 23:56:00 -0700 (PDT)
Message-Id: <20071030.235600.254712083.davem@davemloft.net>
To: npiggin@suse.de
Cc: duaneg@dghda.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031064221.GC12189@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
	<20071031064221.GC12189@wotan.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Wed, 31 Oct 2007 07:42:21 +0100

> Sysrq+T fails to show the stack trace of a running task. Presumably this
> is to avoid a garbled stack, however it can often be useful, and besides
> there is no guarantee that the task won't start running in the middle of
> show_stack(). If there are any correctness issues, then the archietcture
> would have to take further steps to ensure the task is not running.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

This is useful.

Even more useful would be a show_regs() on the cpu where running tasks
are running.  If not a full show_regs() at least a program counter.

That's usually what you're trying to debug and we provide nearly no
way to handle: some task is stuck in a loop in kernel mode and you
need to know exactly where that is.

This is pretty easy to do on sparc64.  In fact I can capture remote
cpu registers even when that CPU's interrupts are disabled.  I suppose
other arches could do a NMI'ish register capture like this as well.

I have a few bug reports that I can't make more progress on because I
currently can't ask users to do something to fetch the registers on
the seemingly hung processor.  This is why I'm harping on this so
much :-)

Anyways, my core suggestion is to add a hook here so platforms can
do the remote register fetch if they want.
