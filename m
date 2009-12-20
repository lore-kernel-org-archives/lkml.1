Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZLTRW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZLTRW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZLTRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:22:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1315 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZLTRWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:22:25 -0500
Subject: Re: sched: restore sanity
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: San Mehat <san@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261322387.4314.22.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 09:22:23 -0800
Message-ID: <1261329743.30458.179.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > >> Probably, but the rest is just as annoying, pr_* is crap.
> > Oh? Out of curiosity whats wrong with it?
> That's what should be asked of printk().

pr_<level> offers some things printk cannot:

o standardization, eliminates frequent missing KERN_ levels
  and missing/typo/misspelled module prefixes  
o visually shorter, fewer chars used, less 80 char wrapping
o finer grained ability to eliminate unnecessary messages
  for embedded systems
o standardized mechanism to prefix messages with module/function
o eventual code reduction via use of a singleton instead of
  duplicated module/function names
o eventual dynamic_debug styled control of prefix by
  module/function

There are quite of number of arbitrarily named module wrapper
macros and functions that build on printk.

Standardizing them around a fewer number of prefixes would
ease grepping for logging.

A standardized logging function to filter messages by
bitmask or level could also be useful. 

> We try to stick to ANSI-C as much as possible, we've got
> kalloc,kfree,strcmp,strnlen and all the other 'regular' C bits,
> deviating from that serves no purpose but seed confusion.

There is a lot of kernel code that isn't 'regular' C.

Nothing in pr_<level> is not ANSI-C, it just builds on printk.

> But I feel this has no place in the core kernel at all, esp when its
> getting in the way of things without offering a single benefit.

What are the negatives of using pr_<level>?


