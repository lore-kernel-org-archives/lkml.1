Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZCYOBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZCYOBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCYOBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:01:34 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61529 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZCYOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:01:33 -0400
Date: Wed, 25 Mar 2009 15:00:35 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090325150035.541e707a@skybase>
In-Reply-To: <49CA1AC3.9080908@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 20:51:31 +0900
Tejun Heo <tj@kernel.org> wrote:

> > With your patches and a RELOC_HIDE version that uses the GOTENT
> > indirection the kernel won't compile because the "X" constraint for
> > the GOTENT access needs a symbol and there are quite a few users that
> > pass a pointer. I do not see a simple solution for that problem yet.
> 
> Ah... okay.  Now I get it.  It wasn't expecting variables there.  How
> about doing the following?
> 
>  #define SHIFT_PERCPU_PTR(ptr, offset) (({				\
> 	 if (__builtin_constant_p(ptr))					\
> 		 do GOTENT trick;					\
> 	 else								\
> 		 RELOC_HIDE();						\
>  }))

That doesn't work because __builtin_constant_p is false for variable
symbols. I would need a __builtin_symbol_p but that doesn't exist.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

