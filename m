Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZA1VXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZA1VXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZA1VXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:23:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZA1VXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:23:35 -0500
Date: Wed, 28 Jan 2009 16:23:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <20090128131327.417b01e1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <20090128131202.21757da6.akpm@linux-foundation.org> <20090128131327.417b01e1.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Andrew Morton wrote:

> On Wed, 28 Jan 2009 13:12:02 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Thought: do we need to do the kmalloc at all?  Perhaps we can instead
> > use a statically allocated per-cpu call_single_data local to
> > kernel/smp.c?  It would need a spinlock or something to protect it...
> 
> (not a spinlock - get_cpu_var/put_cpu_var will suffice)

Is that enough?

The calling IPIs may process the data after smp_call_function is made. 
What happens if two smp_call_functions are executed one after the other? 
The second one may corrupt the data if the IPI function has not executed 
yet.

We may still need that "RELEASE" flag for that case.

-- Steve

