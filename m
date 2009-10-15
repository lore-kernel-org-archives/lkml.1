Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbZJOCpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbZJOCpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZJOCpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:45:10 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:61850 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZJOCpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:45:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEADMn1kpMRK1g/2dsb2JhbACBUdgZhC4E
Date: Wed, 14 Oct 2009 22:39:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>, Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
Message-ID: <20091015023925.GA27959@Krystal>
References: <20091014223657.GC6458@Krystal> <20091015000225.GG6763@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091015000225.GG6763@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 22:34:57 up 57 days, 13:24,  2 users,  load average: 0.27, 0.30,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Oct 14, 2009 at 06:36:57PM -0400, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I just released lib urcu 0.2.3, which is now using autotools. I also
> > integrated automatic architecture detection for old 386 which lack
> > cmpxchg (using a fall-back if necessary). I also use a lock; addl
> > instead of mfence on x86-32 to support a larger variety of older Intel
> > CPUs.
> 
> !!!
> 
> Is there anyone on these lists other than me who has actually used an
> SMP 80386-based system?

SMP 386, ugh, no. But UP 386 yes (at least me). :)

It will become important as the library gets integrated in
distributions.

> 
> Either way, much appreciated for old time's sake.  The things we used
> to do to avoid the need for cmpxchg!  ;-)

In this case I disable signals and take a mutex around the cmpxchg. It's
really a best effort. Should be fine on UP 386, but not so much on SMP
386, as mixing it with assign/xchg pointer could lead to races. I'm not
sure it's worth trying to support 386 SMP though.

Mathieu


> 
> 							Thanx, Paul
> 
> > The build system detects if NR_futex is available in the system
> > headers. It falls back on a more portable alternative if they are not
> > available.
> > 
> > There are also new configuration modes to ./configure for UP-only
> > systems.
> > 
> > As always, the tarballs are available at http://www.lttng.org/urcu
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
