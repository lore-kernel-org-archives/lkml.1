Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbXHQQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbXHQQKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXHQQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:10:33 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:63445 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXHQQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:10:32 -0400
Date: Fri, 17 Aug 2007 12:10:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
Message-ID: <20070817161027.GA30922@Krystal>
References: <11859243121617-git-send-email-clameter@sgi.com> <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com> <20070801182611.GB20713@one.firstfloor.org> <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com> <20070801184026.GC20713@one.firstfloor.org> <Pine.LNX.4.64.0708011144450.22867@schroedinger.engr.sgi.com> <20070801185741.GD20713@one.firstfloor.org> <Pine.LNX.4.64.0708011158110.24852@schroedinger.engr.sgi.com> <20070801191524.GE20713@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070801191524.GE20713@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:04:27 up 18 days, 16:23,  5 users,  load average: 1.99, 2.94, 2.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Wed, Aug 01, 2007 at 11:58:44AM -0700, Christoph Lameter wrote:
> > On Wed, 1 Aug 2007, Andi Kleen wrote:
> > 
> > > That might be on your systems, but for a mainline submission the
> > > standards are higher.
> > 
> > Right that is why I asked for someone to take it over and do mainline work 
> > if that is wanted. I had a couple of requests for these patches.
> 
> The easiest way to solve this would be to switch to reporting cycles.
> That would simplify your patch in fact.
>

Actually, I deal with that in LTTng by having a module that verifies
synchronicity of TSCs across CPUs and, if it's over a certain threshold,
falls back to a sophisticated logical clock (actually, it is a mix of
the TSC of the cpu with highest count and a logical clock) and prints a
printk informing the user of the inaccuracy. I also provide suggestions
on my website of what kernel features must be disabled by users to get
precise timestamps (idle=poll, disable frequency scaling) ans what the
limitations are on Intel and AMD models.

It is packed in a lttng-timestamp-* patchset which I plan to eventually
post for review.

It also provides an architecture independent timestamp read consisting
in jiffies or'd with a logical clock. No locking is required by the
reader (no read reqlock at all). This type of clock could be considered
as "always monotonically increasing", which is the basic condition
required to have a meaningful trace.

Mathieu

> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
