Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbXGSXwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbXGSXwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXGSXwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:52:00 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38222 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755289AbXGSXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:52:00 -0400
Date: Thu, 19 Jul 2007 19:51:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: new text patching for review
Message-ID: <20070719235157.GC30383@Krystal>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <469FC9D4.5070604@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:50:19 up 2 days, 18:24,  2 users,  load average: 0.30, 0.26, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Andi Kleen wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> >   
> >> I see that IRQs are disabled in alternative_instructions(), but it does
> >> not protect against NMIs, which could come at a very inappropriate
> >> moment. MCE and SMIs would potentially cause the same kind of trouble.
> >>
> >> So unless you can guarantee that any code from NMI handler won't call
> >> basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
> >> it won't execute an illegal instruction. Also, the option of temporarily
> >> disabling the NMI for the duration of the update simply adds unwanted
> >> latency to the NMI handler which could be unacceptable in some setups.
> >>     
> >
> > Ok it's a fair point.  But how would you address it ?
> >
> > Even if we IPIed the other CPUs NMIs or MCEs could still happen.
> >
> > BTW Jeremy, have you ever considered that problem with paravirt ops
> > patching? 
> >   
> 
> I remember Zach was thinking about it when he was thinking of making vmi
> a kernel module, but I don't think we discussed it with respect to the
> current patching mechanism.  Though he did discover that at one point
> alternative_instructions() was being run with interrupts enabled, which
> caused surprisingly few problems...
> 
> But, yeah, it seems like it could be a problem.
> 
> > - smp lock patching only ever changes a single byte (lock prefix) of
> > a single instruction
> > - kprobes only ever change a single byte
> >
> > For the immediate value patching it also cannot happen because
> > you'll never modify multiple instructions and all immediate values
> > can be changed atomically. 
> >   
> 
> Are misaligned/cross-cache-line updates atomic?
> 

I align the "immediate values" within the mov instructions on multiples
of the immediate value size so I can update it atomically.

>     J

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
