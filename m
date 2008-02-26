Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYBZI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYBZI5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYBZI5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:57:10 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1346 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYBZI5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:57:09 -0500
Date: Tue, 26 Feb 2008 08:57:35 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226085735.GC20322@shadowen.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org> <20080225233449.GA25448@infradead.org> <20080225214200.yge03wi7ksoccw0k@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225214200.yge03wi7ksoccw0k@webmail.spamcop.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:42:00PM -0500, Pavel Roskin wrote:
> Quoting Christoph Hellwig <hch@infradead.org>:
> 
> >On Mon, Feb 25, 2008 at 02:49:22PM -0800, Andrew Morton wrote:
> >>the things which it finds.
> >>
> >>> +static DECLARE_MUTEX(kmmio_init_mutex);
> >>
> >>That's not a mutex.
> >>
> >>> +	down(&kmmio_init_mutex);
> >>
> >>It's a semaphore.  Please do convert it to a mutex.
> >>
> >>Andy, I'd say that addition of new semaphores is worth a warning - they're
> >>rarely legitimate.
> >
> >I'm not sure that any semaphore should be a warning, but the initializer
> >for semaphore used as binary mutex (DECLARE_MUTEX and init_MUTEX) are
> >worth it.
> 
> It looks like a mutex, it acts like a mutex, but it isn't a mutex,  
> it's a trap for the unwary.  Weird.  I was annoyed by it before; now I  
> see a fellow developer actually getting into that trap.
> 
> I'd say, rename DECLARE_MUTEX to DECLARE_SEMAPHORE and let external  
> code be fixed one way or another (i.e. stick with the "mutex" name or  
> stick with the semaphore functionality if it's really needed).

I like the fact that in evey architecture its defined as:

	#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)

-apw
