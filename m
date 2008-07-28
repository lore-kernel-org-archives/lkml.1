Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYG1Gfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYG1Gfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYG1GfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:35:22 -0400
Received: from ozlabs.org ([203.10.76.45]:48592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYG1GfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:35:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] cpus4096 fixes
Date: Mon, 28 Jul 2008 16:34:42 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
References: <20080727190601.GA764@elte.hu> <200807281042.12860.rusty@rustcorp.com.au> <20080727200636.96da12d0.akpm@linux-foundation.org>
In-Reply-To: <20080727200636.96da12d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281634.43036.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 13:06:36 Andrew Morton wrote:
> On Mon, 28 Jul 2008 10:42:12 +1000 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > The 4k CPU patches have been sliding in without review up until now.
>
> wot?

This surprises you?  I stumbled across the cpumask_of_cpu() bug because I 
happened to want it for stop_machine and read the damned code.  But it lead 
me to the surrounding code, which is pretty questionable.  An arch-specific 
map, rather than depending on NR_CPUS?  Adding set_cpus_allowed_ptr() instead 
of changing set_cpus_allowed()?  Macros which declare things and may or may 
not do an allocation/free?  Finally a patch so horrifically ugly that it 
can't be ignored any more gets all the way to Linus.

Overall, it seems like an attempt to sneak in gradual workarounds for cpumasks 
on the stack, rather than a coherent plan.  I understand the temptation to 
avoid an "are we prepared to pay this price for large NR_CPUS?" discussion, 
but we need it anyway.

And that's what I call "review".
Rusty.
