Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYDVUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYDVUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYDVUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:23:00 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62904 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbYDVUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:22:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAMflDUhMROPA/2dsb2JhbACBUqtP
Date: Tue, 22 Apr 2008 16:22:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [repost PATCH] Fix SMP alternatives : use mutex instead of
	spinlock, text_poke is sleepable
Message-ID: <20080422202256.GA19639@Krystal>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal> <20080422214240.33e79a94@daedalus.pq.iki.fi> <20080422190939.GA30045@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080422190939.GA30045@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:20:56 up 53 days, 16:31,  5 users,  load average: 0.44, 0.35,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Pekka Paalanen <pq@iki.fi> wrote:
> 
> > Ingo,
> > 
> > I see you applied the NX fix. This patch is the other one needed to 
> > make CPU hotplug working. Could you apply this, unless Mathieu has 
> > something against it?
> 
> sure, patch looks sane - applied it and pushed it out. Thanks,
> 
> 	Ingo

Ingo,

The patch found there should also be pulled (at least the
is_vmalloc_addr -> !core_kernel_text bit) :

http://lkml.org/lkml/2008/4/20/192

On x86_64, module code is not in is_vmalloc_addr range, so we can end up
using virt_to_page on module text addresses.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
