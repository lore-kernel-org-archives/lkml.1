Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZCYHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZCYHxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZCYHw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:52:59 -0400
Received: from www.tglx.de ([62.245.132.106]:42658 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZCYHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:52:58 -0400
Date: Wed, 25 Mar 2009 08:50:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903250840440.29264@localhost.localdomain>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org> <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Pekka Enberg wrote:
> On Wed, Mar 25, 2009 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > This makes sense, since we now encourage developers to just call kfree
> > without checking for NULL.
> 
> But those are _error handling paths_ (at least supposed to be). I
> wonder which call-sites are responsible for this. Can frtrace help us
> here?

Why is this an error handler. We replaced tons of 

    if (obj)
       kfree(obj);

constructs all over the kernel with kfree(obj); and let kfree deal
with the NULL pointer.

Thanks,

	tglx

