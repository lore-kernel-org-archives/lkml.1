Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYABKbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYABKbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYABKbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:31:36 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:30426 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751715AbYABKbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:31:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oMOHsnMp3pMRJso9s2Zv7gON7tbBAeHtJ/JBFnvqHRRAnqQsUixEMEwjYxcazOwLifP/ir3WYNCk0IfSMt0tRgqTM79wjAUnH0pFJZ0tIgGhmN1EvXXIZAUHZwQmKQUe4/PrhcDDKxQuWkEpUsI32E9GnR1oq+EazRNb4cB6Z0g=  ;
X-YMail-OSG: oGzi99oVM1l0hIShCLttcU9wf.Vb9J0vteSJkc10Rjte5tiZAyuivKNBXi7OZS6EfjFjrc7e3A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-mm1
Date: Wed, 2 Jan 2008 21:31:15 +1100
User-Agent: KMail/1.9.5
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9DtBq-2jD-3@gated-at.bofh.it> <20071224012524.GA21843@gondor.apana.org.au> <20071230131018.GC16946@elte.hu>
In-Reply-To: <20071230131018.GC16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801022131.15482.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 00:10, Ingo Molnar wrote:
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > Ingo, it's not good that we have cond_resched() definitions
> > > conditionally duplicated in kernel.h - that's increasing the risk of
> > > bugs like this one.
> >
> > Actually, why do we even have cond_resched when real preemption is on?
> > It seems to be a waste of space and time.
>
> due to the BKL. cond_resched() in BKL code breaks up BKL latencies.
>
> i dont mind not doing that though - we should increase the pain for BKL
> users, so that subsystems finally get rid of it altogether.
> lock_kernel() use within the kernel is still rampant - there are still
> more than 400 callsites to lock_kernel().

It would be silly to potentially increase latency in some areas
for CONFIG_PREEMPT kernels, though.

Better may be to detect when there is CONFIG_PREEMPT and
CONFIG_PREEMPT_BKL, and ifdef away the cond_resched in that case
(or -- why do we even make CONFIG_PREEMPT_BKL an option? Are there
really workloads left where it causes throughput regressions?)
