Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbXBEQMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbXBEQMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXBEQMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:12:47 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4550 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXBEQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:12:46 -0500
Date: Mon, 5 Feb 2007 16:12:27 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205161227.GB4563@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205155627.GA8354@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 04:56:27PM +0100, Ingo Molnar wrote:
> btw., this whole select problem is not limited to Aunt Tillie: in a 
> couple of cases in the past few months when i saw some weird code in a 
> driver and tried to enable it i had to search around for many minutes 
> and enable random options to figure out its config dependencies until i 
> had the driver truly enabled. (if there's some easy solution to this 
> then i'm all ears - but i exclude the easiest solution of adding me to 
> the 'aunt' category ;-) I think that by blaming Aunt Tillie you might be 
> missing the real problem.

Adding a 'select' statement might solve that particular problem:

 "What config symbols do I need to turn on to enable FOO"

but it creates another problem which is at precisely the same level.
IOW:

 "What config symbols do I need to turn off to disable FOO"

Both require the use of grep to solve it.  Both are as bad as each
other.  'select' only moves the problem - it doesn't actually solve
anything.

The real problem is that "band-aiding" the problem is all too easy,
so we just bung a select in.  We're actually storing up bigger problems
for the future, making the kernel configuration system more and more
complex, sometimes creating circular dependencies through select/depends,
basically turning it into something several orders of magnitude worse
than the original shell scripts.

The only real way I see the problem truely getting solved is if folk
start standing up against throwing "select" in so there's some
motivation to actually fix the underlying problem.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
