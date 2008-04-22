Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYDVOGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYDVOGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYDVOGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:06:39 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:62229 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbYDVOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:06:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAOKNDUhMROPA/2dsb2JhbACBUqsS
Date: Tue, 22 Apr 2008 10:06:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 page fault scheduler race
Message-ID: <20080422140636.GA1683@Krystal>
References: <20080422132151.GA32120@Krystal> <20080422132614.GC7311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080422132614.GC7311@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:55:04 up 53 days, 10:06,  6 users,  load average: 0.43, 0.80,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > You are right in that x86_64 does not seems to play as safely as 
> > x86_32 on this matter; it uses current->mm. Probably it shouldn't 
> > assume "current" is valid. Actually, I don't see where x86_64 disables 
> > interrupts around __switch_to, so this would seem to be a race 
> > condition. Or have I missed something ?
> 
> the scheduler disables interrupts around __switch_to(). (x86 does not 
> set __ARCH_WANT_INTERRUPTS_ON_CTXSW)
> 
> 	Ingo


Ok, so I guess it's only useful to NMIs then. However, it makes me
wonder why this comment was there in the first place on x86_32
vmalloc_fault() and why it uses read_cr3() :

        * Do _not_ use "current" here. We might be inside
        * an interrupt in the middle of a task switch..

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
