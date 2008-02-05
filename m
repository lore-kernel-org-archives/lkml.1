Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYBEVPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYBEVPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYBEVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:14:58 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:50612 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbYBEVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:14:57 -0500
Date: Tue, 5 Feb 2008 23:14:52 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86 mmiotrace: fix relay-buffer-full flag for SMP
Message-ID: <20080205231452.16cc2f88@daedalus.pq.iki.fi>
In-Reply-To: <47A8CA97.30008@cosmosbay.com>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223046.668309be@daedalus.pq.iki.fi>
	<47A8CA97.30008@cosmosbay.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 21:44:07 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Pekka Paalanen a écrit :
> > diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
> > index 82ae920..f492b65 100644
> > --- a/arch/x86/kernel/mmiotrace/mmio-mod.c
> > +++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
> > @@ -47,9 +48,13 @@ struct trap_reason {
> >  	int active_traces;
> >  };
> >  
> > +/* Accessed per-cpu. */
> >  static struct trap_reason pf_reason[NR_CPUS];
> >  static struct mm_io_header_rw cpu_trace[NR_CPUS];
> >  
> > +/* Access to this is not per-cpu. */
> > +static atomic_t dropped[NR_CPUS];
> > +
> 
> Please dont introduce NR_CPUS new arrays, since people are working hard to zap 
> them from kernel.
> 
> You probably can use a per_cpu variable ?

Yes, it would probably be more appropriate to use DEFINE_PER_CPU()
for 'pf_reason' and 'cpu_trace', but I wasn't sure since the examples
of DEFINE_PER_CPU I saw always had integers or pointers, not
whole structs. Is it okay for whole structs?

'dropped' on the other hand is not accessed in per-cpu style, any cpu
may access any element. DEFINE_PER_CPU is not valid here, is it?

Thanks for the note, I knew I should fix that at some point.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
