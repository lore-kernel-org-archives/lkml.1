Return-Path: <linux-kernel-owner+w=401wt.eu-S1762749AbYBZPUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762749AbYBZPUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYBZPTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:19:53 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3238 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYBZPTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:19:52 -0500
Date: Tue, 26 Feb 2008 15:20:57 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Pavel Roskin <proski@gnu.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226152057.GG20322@shadowen.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org> <20080225233449.GA25448@infradead.org> <20080226102149.GE20322@shadowen.org> <20080226104948.GA32659@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226104948.GA32659@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:49:48AM +0100, Ingo Molnar wrote:
> 
> * Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > Ok, so that would be the following, work for everyone?
> > 
> > WARNING: mutexes are preferred for single holder semaphores
> > #1: FILE: Z95.c:1:
> > +       DECLARE_MUTEX(&foo);
> > 
> > WARNING: mutexes are preferred for single holder semaphores
> > #3: FILE: Z95.c:3:
> > +       init_MUTEX(&foo);
> 
> yeah.
> 
>   Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> also i guess init_MUTEX_LOCKED() should emit a "this should be a 
> completion" warning.

Thats easy enough.  Though your tone here implies its less definatly
wrong than the other use forms.  Do we want gentle language here?

	"consider using a completion"

> i guess non-DEFINE_SPINLOCK old-style spinlock definition:
> 
>   spinlock_t lock = SPIN_LOCK_UNLOCKED;
> 
> should emit a 'use DEFINE_SPINLOCK' warning as well?

Those (SPIN_LOCK_UNLOCKED & RW_LOCK_UNLOCKED) we already pick up and
indicate are deprecated.

-apw
