Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYKFONi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYKFONi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYKFONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:13:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:55091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYKFON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:13:29 -0500
Date: Thu, 6 Nov 2008 06:14:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106061408.03c10337@infradead.org>
In-Reply-To: <1225976138.7803.4485.camel@twins>
References: <20081105094902.27ec4b39@infradead.org>
	<1225976138.7803.4485.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 13:55:38 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2008-11-05 at 09:49 -0800, Arjan van de Ven wrote:
> > From 63c1b869d94eb31a98015af09fb24e22151f2f00 Mon Sep 17 00:00:00
> > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Tue, 4 Nov 2008 21:08:11 -0800
> > Subject: [PATCH] ftrace: add an fsync tracer
> > 
> > fsync() (and its cousin, fdatasync()) are important chokepoints in
> > the kernel as they imply very expensive operations, both in terms
> > of filesystem operations (ext3 writes back its entire journal) as
> > well as the block layer (fsync() implies sending a cache flushing
> > barrier to the SATA/SCSI disk).
> > 
> > This tracer makes a log of which application calls fsync() on which
> > file, so that developers and others interested in finding these
> > choke points can locate them and fix them in the apps that call
> > this function.
> 
> Sorry, but I have to object to such single purpose tracers..
> 
> If we go this way we'll end up with a gazillion little tracers, non of
> which are really useful.
> 
> Please work on getting something like a syscall tracer, or lttng like
> event tracer.
> 

btw a syscall tracer is not long term right, just like system call
level auditing was the wrong thing: you don't have the real information
of what's being worked on. having the trace points on the do_FOO()
level is the right thing, and that's exactly what my patch does.
