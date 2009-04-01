Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZDAIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZDAIrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZDAIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:47:46 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39517 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZDAIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:47:44 -0400
Date: Wed, 1 Apr 2009 10:47:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: tj@kernel.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       lethal@linux-sh.org, rmk@arm.linux.org.uk, starvik@axis.com,
       ralf@linux-mips.org, cooloney@kernel.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090401104737.22c8c66c@skybase>
In-Reply-To: <20090401.013702.66171229.davem@davemloft.net>
References: <20090401101054.0a4b187d@skybase>
	<49D3231D.2040403@kernel.org>
	<20090401103257.12c2517e@skybase>
	<20090401.013702.66171229.davem@davemloft.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 01:37:02 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date: Wed, 1 Apr 2009 10:32:57 +0200
> 
> > The code sequence with @GOT:
> > 
> > 	larl	%r12,_GLOBAL_OFFSET_TABLE_
> > 	lg	%r1,symbol@GOT(%r12)
> > 
> > is equivalent to:
> > 
> > 	larl	%r1,symbol@GOTENT
> > 	lg	%r1,0(%r1)
> > 
> > The advantage of the second code sequence is that it need a single
> > register and the size of the GOT is not limited to 4K as in the first
> > example (the offset in an RX format instruction is limited to 12 bits -
> > but that is probably something you don't want to know ;-).
> 
> If practical I think you guys should just force all of the module
> address space below 4GB virtually, as we do on sparc64.  It's a good
> way to avoid all of these problems.

We have thought about that solution as well but it not really a good
one. For a machine with more than 4GB of memory we would either loose
the memory that overlaps with the module area or we'd have to play
nasty remapping tricks. On s390 the kernel image is linked to address 0
(PAGE_OFFSET==0) and we have a simple 1:1 mapping for all real memory.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

