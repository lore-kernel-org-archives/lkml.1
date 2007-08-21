Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXHUXwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXHUXwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXHUXwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:52:09 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:47248 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722AbXHUXwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:52:07 -0400
Date: Tue, 21 Aug 2007 19:47:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821234702.GE29691@Krystal>
References: <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com> <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:44:29 up 23 days, 3 min,  3 users,  load average: 0.11, 0.33, 0.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Using cmpxchg_local vs cmpxchg has a clear impact on the fast paths, as
> > shown below: it saves about 60 to 70 cycles for kmalloc and 200 cycles
> > for the kmalloc/kfree pair (test 2).
> 
> Hmmmm.. I wonder if the AMD processors simply do the same in either 
> version.

No supposed to. I remember having posted numbers that show a
difference.

Are you running a UP or SMP kernel ? If you run a UP kernel, the
cmpxchg_local and cmpxchg are identical.

Oh, and if you run your tests at boot time, the alternatives code may
have removed the lock prefix, therefore making cmpxchg and cmpxchg_local
exactly the same.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
