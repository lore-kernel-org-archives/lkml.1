Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYBZKVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYBZKVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYBZKUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:20:54 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4536 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYBZKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:20:53 -0500
Date: Tue, 26 Feb 2008 10:21:49 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226102149.GE20322@shadowen.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org> <20080225233449.GA25448@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225233449.GA25448@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 06:34:49PM -0500, Christoph Hellwig wrote:
> On Mon, Feb 25, 2008 at 02:49:22PM -0800, Andrew Morton wrote:
> > the things which it finds.
> > 
> > > +static DECLARE_MUTEX(kmmio_init_mutex);
> > 
> > That's not a mutex.
> > 
> > > +	down(&kmmio_init_mutex);
> > 
> > It's a semaphore.  Please do convert it to a mutex.
> > 
> > Andy, I'd say that addition of new semaphores is worth a warning - they're
> > rarely legitimate.
> 
> I'm not sure that any semaphore should be a warning, but the initializer
> for semaphore used as binary mutex (DECLARE_MUTEX and init_MUTEX) are
> worth it.

Ok, so that would be the following, work for everyone?

WARNING: mutexes are preferred for single holder semaphores
#1: FILE: Z95.c:1:
+       DECLARE_MUTEX(&foo);

WARNING: mutexes are preferred for single holder semaphores
#3: FILE: Z95.c:3:
+       init_MUTEX(&foo);

-apw
