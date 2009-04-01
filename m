Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZDAJJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZDAJJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZDAJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:08:54 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:53118 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDAJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:08:53 -0400
Date: Wed, 1 Apr 2009 11:08:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, lethal@linux-sh.org, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, cooloney@kernel.org,
       kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090401110846.0536df11@skybase>
In-Reply-To: <49D32AE5.70709@kernel.org>
References: <20090401101054.0a4b187d@skybase>
	<49D3231D.2040403@kernel.org>
	<20090401103257.12c2517e@skybase>
	<20090401.013702.66171229.davem@davemloft.net>
	<20090401104737.22c8c66c@skybase>
	<49D32AE5.70709@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 17:50:45 +0900
Tejun Heo <tj@kernel.org> wrote:

> Martin Schwidefsky wrote:
> > On Wed, 01 Apr 2009 01:37:02 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> >> If practical I think you guys should just force all of the module
> >> address space below 4GB virtually, as we do on sparc64.  It's a good
> >> way to avoid all of these problems.
> > 
> > We have thought about that solution as well but it not really a good
> > one. For a machine with more than 4GB of memory we would either loose
> > the memory that overlaps with the module area or we'd have to play
> > nasty remapping tricks. On s390 the kernel image is linked to address 0
> > (PAGE_OFFSET==0) and we have a simple 1:1 mapping for all real memory.
> > 
> 
> Also, there is no guarantee that the offset from dynamic allocator
> will fall in the same 4G.  There is reserve mechanism for static ones
> for archs which need it but for dynamic ones, the offset can be any
> value.

If we map the modules with a 4GB distance to the main kernel image then
we don't have to worry about the offsets anymore. The compiler could
just use LARL to get the address of the static per-cpu variables and
SHIFT_PERCPU_PTR could be a RELOC_HIDE.

It just that the remapping we need to do is sooo icky ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

