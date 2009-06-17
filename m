Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZFQQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZFQQDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZFQQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:03:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbZFQQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:03:13 -0400
Date: Wed, 17 Jun 2009 09:01:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <20090617074719.GB26664@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906170853580.16802@localhost.localdomain>
References: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
 <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop> <20090616044601.GB28596@wotan.suse.de> <alpine.LFD.2.01.0906161141290.3282@localhost.localdomain> <20090617074719.GB26664@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Nick Piggin wrote:
> 
> In some cases perhaps it is difficult. In others it should be
> pretty natural. Lots of memory allocating paths pass gfp
> a long way down the stack.

I agree that some cases would be pretty natural. In fact, that's what we 
started out doing. On the x86 side, we didn't have a lot of issues in 
testing, and we fixed them up by using GFP_NOWAIT (see for example 
cpupri_init() in kernel/sched_cpupri.c, or init_irq_default_affinity() in 
kernel/irq/handle.c - both of which were fixed up in that phase).

Those paths, in fact, in general already had "bootmem" flags etc. And x86 
doesn't need to initialize a lot of state at bootup. 

Then Ben happened, and crazy PPC ioremap crap. 

So the problem is exactly that it was perfectly natural to pass down a gfp 
or other flag in _some_ cases. And then in a few cases it's much more 
painful.

		Linus
