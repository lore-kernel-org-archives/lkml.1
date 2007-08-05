Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbXHEUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbXHEUl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXHEUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:41:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18434 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbXHEUlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VNsqcOkicqhwHmh2ijDB7t5ejUMW7jUtl7BLgicPTGuzBe/oWsKh+bjgIUzErqC1Xr8VNqGYUpQ2NaqI65hgkaTakPYcI+aXF7jkxxSB7Jg4uLAMz8eE+XPlibraUTJoNTHXu6RzKr1SpSaG7LiQAb5vMeRZmnbrJCEk4tfukss=
Date: Sun, 5 Aug 2007 22:41:14 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] UML - Simplify helper stack handling
Message-ID: <20070805204114.GA19857@dreamland.darkstar.lan>
References: <20070614202655.GA9647@c2.user-mode-linux.org> <20070627233701.8e53f3cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627233701.8e53f3cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wed, Jun 27, 2007 at 11:37:01PM -0700, Andrew Morton ha scritto: 
> 
> So I'm running the generic version of this on i386 with 8k stacks (below),
> with a quick LTP run.
> 
> Holy cow, either we use a _lot_ of stack or these numbers are off:
> 
> vmm:/home/akpm> dmesg -s 1000000|grep 'bytes left' 
> khelper used greatest stack depth: 7176 bytes left
> khelper used greatest stack depth: 7064 bytes left
> khelper used greatest stack depth: 6840 bytes left
> khelper used greatest stack depth: 6812 bytes left
> hostname used greatest stack depth: 6636 bytes left
> uname used greatest stack depth: 6592 bytes left
> uname used greatest stack depth: 6284 bytes left
> hotplug used greatest stack depth: 5568 bytes left
> rpc.nfsd used greatest stack depth: 5136 bytes left
> chown02 used greatest stack depth: 4956 bytes left
> fchown01 used greatest stack depth: 4892 bytes left
> 
> That's the sum of process stack and interrupt stack, but I doubt if this
> little box is using much interrupt stack space.
> 
> No wonder people are still getting stack overflows with 4k stacks...

Hi Andrew,
I was a bit worried about stack usage on my setup and google found your
mail :P

FYI:

khelper used greatest stack depth: 3228 bytes left
khelper used greatest stack depth: 3124 bytes left
busybox used greatest stack depth: 2808 bytes left
modprobe used greatest stack depth: 2744 bytes left
busybox used greatest stack depth: 2644 bytes left
modprobe used greatest stack depth: 1836 bytes left
modprobe used greatest stack depth: 1176 bytes left
java used greatest stack depth: 932 bytes left
java used greatest stack depth: 540 bytes left

I'm running git-current, with 4KiB stacks; filesystems are ext3 and XFS
on LVM (on libata devices).
Does it make sense to raise STACK_WARN to get a stack trace in do_IRQ?
Or is 540 bytes still "safe" taking into account the separate IRQ stack?

Luca
-- 
42
