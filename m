Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYKTEoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYKTEoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYKTEoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:44:15 -0500
Received: from ozlabs.org ([203.10.76.45]:45453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYKTEoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:44:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Date: Thu, 20 Nov 2008 15:14:08 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, npiggin@suse.de, axboe@kernel.dk
References: <20081119144710.59CA1DDDDB@ozlabs.org> <200811201421.50518.nickpiggin@yahoo.com.au>
In-Reply-To: <200811201421.50518.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201514.09511.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 13:51:49 Nick Piggin wrote:
> I don't like changing of this whole smp_call_function_many scheme
> with no justification or even hint of it in the changelog.

Hi Nick,

Hmm, it said "if allocation fails we fallback to smp_call_function_single
rather than using the baroque quiescing code."

More words would have been far less polite :)

> Of course it is obvious that smp_call_function_mask can be implemented
> with multiple call singles. But some architectures that can do
> broadcast IPIs (or otherwise a little extra work eg. in programming
> the interrupt controller) will lose here.
>
> Also the locking and cacheline behaviour is probably actually worse.

Dude, we've failed kmalloc.  To paraphrase Monty Python, the parrot is fucked.   
By this stage the disks are churning, the keyboard isn't responding and the 
OOM killer is killing the mission-critical database and other vital apps.  
Everything else is failing on random syscalls like unlink().  Admins wondering 
how long it'll take to fsck if they just hit the big red switch now.

OK, maybe it's not that bad, but worrying about cacheline behaviour?  I'd 
worry about how recently that failure path has been tested.

I can prepare a separate patch which just changes this over, rather than doing 
it as part of the smp_call_function_many() conversion, but I couldn't stomach 
touching that quiescing code :(

Rusty.
