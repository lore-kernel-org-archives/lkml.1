Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXHTUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXHTUll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXHTUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:41:30 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:39593 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbXHTUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:41:28 -0400
Date: Mon, 20 Aug 2007 16:41:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070820204126.GA22507@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:38:26 up 21 days, 20:57,  4 users,  load average: 1.24, 1.87, 1.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:
> 
> > already present in cmpxchg_386_u32 tells much about how this cmpxchg
> > implementation should not be used in a SMP context. However, the cmpxchg_local
> > can perfectly use this fallback, since it only needs to be atomic wrt the local
> > cpu.
> 
> Do you have an example where the use of cmpxchg_local is a performance 
> benefit when actually used in code? cmpxchg is already problematic
> functionality since it is not available on all platforms.

Yes, I use it as synchronization mechanism for my buffer management algorithm
in LTTng. Since I write in per-cpu buffers and want to be as reentrant
as possible wrt other contexts (dealing with NMI as worse case, but also
applies to MCE..), I use local_cmpxchg to reserve space in my buffers.
It is faster than the standard cmpxchg.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
