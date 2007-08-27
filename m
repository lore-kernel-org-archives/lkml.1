Return-Path: <linux-kernel-owner+w=401wt.eu-S1764849AbXH0VZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764849AbXH0VZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbXH0VPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:15:16 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:35020 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758353AbXH0VPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:15:14 -0400
Date: Mon, 27 Aug 2007 17:10:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070827211003.GA10627@Krystal>
References: <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com> <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com> <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com> <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:08:55 up 28 days, 21:27,  7 users,  load average: 1.10, 1.17, 1.05
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> I think the simplest solution may be to leave slub as done in the patch 
> that we developed last week. The arch must provide a cmpxchg_local that is 
> performance wise the fastest possible. On x86 this is going to be the 
> cmpxchg_local on others where cmpxchg is slower than interrupt 
> disable/enable this is going to be the emulation that does
> 
> interrupt disable
> 
> cmpchg simulation
> 
> interrupt enable
> 
> 
> If we can establish that this is not a performance regression then we have 
> a clean solution source code wise. It also minimizes the interrupt holdoff 
> for the non-cmpxchg_local arches. However, it means that we will have to 
> disable interrupts twice for the slow path. If that is too expensive then 
> we need a different solution.
> 

cmpxchg_local is not used on the slow path... ?

Did you meant:

it means that we will have to disable preemption _and_ interrupts on the
fast path for non-cmpxchg_local arches ?

Or maybe am I thinking about the wrong code snippet there ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
