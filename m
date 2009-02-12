Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZBLBpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZBLBpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZBLBpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:45:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:51767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZBLBpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:45:06 -0500
Date: Thu, 12 Feb 2009 02:45:03 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: next Feb 10: mm/slqb build break
Message-ID: <20090212014503.GD30043@wotan.suse.de>
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <49914790.6050008@in.ibm.com> <49914EE7.7030205@in.ibm.com> <84144f020902100353x4074f342ne4d61483074a06b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020902100353x4074f342ne4d61483074a06b7@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:53:51PM +0200, Pekka Enberg wrote:
> On Tue, Feb 10, 2009 at 11:54 AM, Sachin P. Sant <sachinp@in.ibm.com> wrote:
> > Sachin P. Sant wrote:
> >>
> >> Hi Stephen,
> >>
> >> Todays next randconfig build on powerpc fails with
> >>
> >>  CC      mm/slqb.o
> >> mm/slqb.c: In function __slab_free:
> >> mm/slqb.c:1648: error: implicit declaration of function
> >> slab_free_to_remote
> >> mm/slqb.c: In function kmem_cache_open:
> >> mm/slqb.c:2174: error: implicit declaration of function
> >> kmem_cache_dyn_array_free
> >> mm/slqb.c:2175: warning: label error_cpu_array defined but not used
> >> mm/slqb.c: In function kmem_cache_destroy:
> >> mm/slqb.c:2294: error: implicit declaration of function
> >> claim_remote_free_list
> >> mm/slqb.c: In function kmem_cache_reap_percpu:
> >> mm/slqb.c:2547: error: implicit declaration of function
> >> flush_remote_free_cache
> >> mm/slqb.c: In function kmem_cache_init:
> >> mm/slqb.c:2783: error: per_cpu__kmem_cpu_nodes undeclared (first use in
> >> this function)
> >> mm/slqb.c:2783: error: (Each undeclared identifier is reported only once
> >> mm/slqb.c:2783: error: for each function it appears in.)
> >> mm/slqb.c:2784: error: kmem_cpu_cache undeclared (first use in this
> >> function)
> >> make[1]: *** [mm/slqb.o] Error 1
> >> make: *** [mm] Error 2
> >
> > CONFIG_SMP is not set hence the failure.
> 
> Actually, that's not the root cause here. You seem to have CONFIG_SMP
> disabled but CONFIG_NUMA enabled. That's not possible on x86 which
> makes me think it's a ppc kconfig bug. Hmm?

If it is really a valid config, then we should be able to make
slqb build with it...

