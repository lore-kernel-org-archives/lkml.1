Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbYEMPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbYEMPa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYEMPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:30:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYEMPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:30:19 -0400
Date: Tue, 13 May 2008 08:23:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Gianni Tedesco <gxt@cs.nott.ac.uk>, arges@linux.vnet.ibm.com,
       Maynard Johnson <maynardj@us.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: oprofile BUG() in current kernel.
Message-Id: <20080513082313.cbbe81af.akpm@linux-foundation.org>
In-Reply-To: <48296C96.8060000@cosmosbay.com>
References: <1210593756.3708.7.camel@dao.KWGR614>
	<19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	<1210599105.3479.1.camel@dao.KWGR614>
	<48285002.9080702@us.ibm.com>
	<1210610283.7218.4.camel@snuffleupagus>
	<20080513014010.e0723e01.akpm@linux-foundation.org>
	<1210671688.3472.10.camel@dao.KWGR614>
	<48296C96.8060000@cosmosbay.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 12:25:26 +0200 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Current module loader only allocates percpu room by examining 
> ".data.percpu" section and should be augmented to also look at 
> ".data.percpu.shared_aligned"
> Or, change DEFINE_PER_CPU_SHARED_ALIGNED() for modules (to use 
> ".data.percpu" only)

Well that's a little landmine.  Seems that this was the first attempt to
use DEFINE_PER_CPU_SHARED_ALIGNED from within a module.

> Anyway, with the per_cpu conversion of cpu_buffer, we dont need to 
> request cache_line alignment anymore
>
> [PATCH] oprofile: Dont request cache line alignment for cpu_buffer

Thanks.  Silly me for looking at the nearly-one-year-old
DEFINE_PER_CPU_SHARED_ALIGNED and assuming that it worked :(


