Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZF0RSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZF0RSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZF0RSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:18:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZF0RSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:18:31 -0400
Date: Sat, 27 Jun 2009 19:17:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com, ntl@pobox.com, mel@csn.ul.ie,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, steiner@sgi.com,
       rientjes@google.com, containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: only clear node_states for 64bit
Message-ID: <20090627171714.GD21595@elte.hu>
References: <alpine.DEB.1.10.0906041309230.8080@gentwo.org> <4A2803D1.4070001@kernel.org> <m3bpokiv0u.fsf@pobox.com> <4A3B49BA.40100@kernel.org> <m3prd0havh.fsf@pobox.com> <4A3D7419.8040305@kernel.org> <m3my807ug3.fsf@pobox.com> <4A3FA58A.3010909@kernel.org> <20090626135428.d8f88a70.akpm@linux-foundation.org> <4A4538FE.2090101@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4538FE.2090101@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Andrew Morton wrote:
> > On Mon, 22 Jun 2009 08:38:50 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Nathan reported that
> >> | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
> >> | Author: Yinghai Lu <yinghai@kernel.org>
> >> | Date:   Tue Jun 16 15:33:00 2009 -0700
> >> |
> >> |    page-allocator: clear N_HIGH_MEMORY map before we set it again
> >> |    
> >> |    SRAT tables may contains nodes of very small size.  The arch code may
> >> |    decide to not activate such a node.  However, currently the early boot
> >> |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
> >> |    active although these nodes have no present pages.
> >> |    
> >> |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
> >>
> >> the cpuset.mems cgroup attribute on an i386 kvm guest
> >>
> >> fix it by only clearing node_states[N_NORMAL_MEMORY] for 64bit only.
> >> and need to do save/restore for that in find_zone_movable_pfn
> >>
> > 
> > There appear to be some words omitted from this changelog - it doesn't
> > make sense.
> > 
> > I think that perhaps a line got deleted before "the cpuset.mems cgroup
> > ...".  That was the line which actualy describes the bug which we're
> > fixing.  Or perhaps it was a single word?  "zeroes".
> > 
> > 
> > I did this:
> > 
> > Nathan reported that
> > : 
> > : | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
> > : | Author: Yinghai Lu <yinghai@kernel.org>
> > : | Date:   Tue Jun 16 15:33:00 2009 -0700
> > : |
> > : |    page-allocator: clear N_HIGH_MEMORY map before we set it again
> > : |
> > : |    SRAT tables may contains nodes of very small size.  The arch code may
> > : |    decide to not activate such a node.  However, currently the early boot
> > : |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
> > : |    active although these nodes have no present pages.
> > : |
> > : |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
> > : 
> 
> "
> > : unintentionally and incorrectly clears the cpuset.mems cgroup attribute on
> > : an i386 kvm guest
> "
> ==> 
> 
> 32bit assume NORMAL_MEMORY bit and HIGH_MEMORY bit are set for 
> Node0 always.

Where in the code is this assumption?

> and some code only check if HIGH_MEMORY is there to know if 
> NORMAL_MEMORY is there.

Which code is that exactly?

	Ingo
