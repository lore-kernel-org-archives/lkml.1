Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCYICQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCYICQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZCYIBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:01:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42664 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZCYIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:01:54 -0400
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
In-Reply-To: <alpine.LFD.2.00.0903250840440.29264@localhost.localdomain>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
	 <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	 <alpine.LFD.2.00.0903250840440.29264@localhost.localdomain>
Date: Wed, 25 Mar 2009 10:01:51 +0200
Message-Id: <1237968111.30175.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Mar 25, 2009 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > This makes sense, since we now encourage developers to just call kfree
> > > without checking for NULL.

On Wed, 25 Mar 2009, Pekka Enberg wrote: 
> > But those are _error handling paths_ (at least supposed to be). I
> > wonder which call-sites are responsible for this. Can frtrace help us
> > here?

On Wed, 2009-03-25 at 08:50 +0100, Thomas Gleixner wrote:
> Why is this an error handler. We replaced tons of 
> 
>     if (obj)
>        kfree(obj);
> 
> constructs all over the kernel with kfree(obj); and let kfree deal
> with the NULL pointer.

We encourage developers not to check for kfree() in the common
out-of-memory error handling paths. But what Steven's results suggest is
that the common case is something like this:

   void *p = NULL;

   if (/* unlikely condition */)
       p = kmalloc(...);

   kfree(p);

which, quite frankly, doesn't make much sense to me. That's why I would
really want to know which call-sites are causing this before applying
the patch.

			Pekka

