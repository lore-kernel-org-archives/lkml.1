Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbZEBVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbZEBVB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZEBVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:01:49 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:36272 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbZEBVBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:01:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAG9N/ElMQW1W/2dsb2JhbACBUMsog30F
Date: Sat, 2 May 2009 17:01:47 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090502210147.GA23766@Krystal>
References: <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011527260.7795@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:56:10 up 63 days, 17:22,  3 users,  load average: 0.17, 0.39,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 1 May 2009, Mathieu Desnoyers wrote:
> 
> > What I do here is to let those u8 counters increment as free-running
> > counters. Yes, they will periodically overflow the 8 bits. But I don't
> > rely on this for counting the number of increments we need between
> > global counter updates : I use the bitmask taken from the threshold
> > value (which is now required to be a power of two) to detect 0, 1, 2, 3,
> > 4, 5, 6 or 7-bit counter overflow. Therefore we can still have the kind
> > of granularity currently provided. The only limitation is that we have
> > to use powers of two for the threshold, so we end up counting in power
> > of two modulo, which will be unaffected by the u8 overflow.
> 
> Ack. Got it. Looks good.
> 

Modifying mmzone.h "struct per_cpu_pageset" so it uses percpu dynamic
allocation seems to be the far-reaching part of the modification (of a
subsystem I'm not completely familiar with, including NUMA special
cases). Is there any patch already doing this kind of modification
floating around ?

I'd be glad to give a try at some percpu_add_return counters experiments
if percpu struct per_cpu_pageset allocation happens to be already
available.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
