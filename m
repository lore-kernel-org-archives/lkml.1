Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXHLVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXHLVTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbXHLVTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:19:25 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:41000 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756607AbXHLVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:19:24 -0400
Date: Sun, 12 Aug 2007 17:14:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] Immediate Values
Message-ID: <20070812211416.GA10051@Krystal>
References: <20070812150702.769065566@polymtl.ca> <1186943243.2854.17.camel@laptopd505.fenrus.org> <20070812185501.GA4480@Krystal> <1186952324.2854.21.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1186952324.2854.21.camel@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:09:36 up 13 days, 21:28,  2 users,  load average: 1.64, 2.16, 2.04
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> > > 
> > > I have a concern; you seem to be patching potentially "live" code....
> > > 
> > > there are basically two options
> > > 1) you run the risk of triple faulting (patching an instruction while
> > > some other core/cpu may be decoding it may cause a triple fault)
> > > 2) you do an IPI to all other cpus and prevent them from executing any
> > > code except a small loop during the patching... this is expensive.
> > > 
> > > To be honest, neither sound very attractive to me ;(
> > > 
> > 
> > Yup, the concern is appropriate. That's why I dealt with it in the
> > "Immediate Values - i386 Optimization" patch. (I guess your concern
> > is specific to i386, x86_64 and ia64).
> 
> it's specific to all smp architectures I suppose

I would wait to see the references before doing such presumptions..
AFAIK, powerpc does not suffer from such problems. I have also seen
nothing of this kind about AMD processors, so it seems to be Intel
specific.

> > 
> > I have currently only implemented the i386 optimization, but x86_64 and
> > ia64 should be similar.
> > 
> > The triple fault in question is discussed in Intel's errata under the
> > title "Centrino Duo Processor Technology Specification Update, AH33.
> > Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
> > Instruction Execution Results." (if you refer to something else, please
> > tell me).
> 
> Core2DUO is only one generation of Intel processors; however I know that
> several other (if not all of them) have issues with this kind of thing
> in ring 0; all subtly different ;(
> 

Yes, this errata can be found starting at the Pentium III (as explained
in my patch). Can you elaborate a little more on the differences ? From
what I have seem, the basic problem is always the same from PIII to
core2 Duo: instruction prefetch.


> All other alternatives are ok right now (they all run in UP mode),
> but... I'm just very nervous about the amount of CPU errata in this kind
> of scenario. And I'm not just talking Intel, I wouldn't be surprised if
> the other x86 CPU vendors also have issues with this; I don't know how
> well they specify their errata though..
> 
> 

You seem to be pointing out to a lot of erratas, when there is, from
what I reckon, only one (basically the same) from PIII to Core 2 Duo,
which is Intel specific. I have looked around and ia64 also seems to be
affected by this. Can you point us out to other documentation sources
please ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
