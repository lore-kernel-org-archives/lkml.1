Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZDWWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZDWWRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbZDWWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:17:15 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:56239 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932096AbZDWWRO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:17:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEIAM+A8ElMQW1W/2dsb2JhbACBUJVUuRGCLoFGBQ
Date: Thu, 23 Apr 2009 18:17:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mark.langsdorf@amd.com, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090423221711.GA30855@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090423080645.GF22606@elte.hu> <20090423131941.GA11261@Krystal> <200904231541.18041.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200904231541.18041.a.miskiewicz@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:11:32 up 54 days, 18:37,  1 user,  load average: 0.07, 0.22,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> On Thursday 23 of April 2009, Mathieu Desnoyers wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > > " // Opteron Rev E has a bug in which on very rare occasions a locked
> > > >   // instruction doesn't act as a read-acquire barrier if followed by a
> > > >   // non-locked read-modify-write instruction.  Rev F has this bug in
> > > >   // pre-release versions, but not in versions released to customers,
> > > >   // so we test only for Rev E, which is family 15, model 32..63
> > > > inclusive.
> > >
> > > Dunno. The fix looks a bit intrusive (emits a NOP even on good
> > > CPUs). Also, the text above says "not in versions released to
> > > customers".
> > >
> > > So unless there's an official erratum or reports in the field (not
> > > from early prototype systems shipped to developers) i'd not rush to
> > > apply it, just yet.
> >
> > Actually, Operon Rev E has this bug in the field (family 15, model
> > 32..64). Rev F only had the bug in pre-releases.
> >
> > But yes, it's bad that it drags so many code additions to something as
> > critical as cmpxchg. I start to think it might be better to just
> > disallow bringing up more than one CPU on these machines.
> 
> That probably would be even worse than what we have now. This bug doesn't 
> manifest too often in a noticeable way here (I have few such machines here, 
> mostly 2 x dual core; once per few months mysql dies) and loosing 3 of 4 cores 
> (or 1 cpu of 2; depends on what you mean) doesn't sound like fun.
> 

Having silent data corruption does not sound like fun neither. Another
alternative, when we detect those CPUs, is to printk a warning telling :

"AMD Opteron family X model Y is known to corrupt data on SMP due"
"to incorrect cmpxchg instruction memory barriers. Please contact"
"AMD for more information."

And activate the "tainted" kernel flag. This way, we won't be bothered
trying to fix AMD bugs, and it will officially become AMD's problem.

Mathieu

> > Mathieu
> 
> 
> -- 
> Arkadiusz Miśkiewicz        PLD/Linux Team
> arekm / maven.pl            http://ftp.pld-linux.org/
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
