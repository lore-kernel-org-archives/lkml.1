Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYKFMzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYKFMzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYKFMy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:54:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYKFMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:54:56 -0500
Subject: Re: [PATCH] ftrace: add an fsync tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081105094902.27ec4b39@infradead.org>
References: <20081105094902.27ec4b39@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 13:55:38 +0100
Message-Id: <1225976138.7803.4485.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 09:49 -0800, Arjan van de Ven wrote:
> From 63c1b869d94eb31a98015af09fb24e22151f2f00 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 4 Nov 2008 21:08:11 -0800
> Subject: [PATCH] ftrace: add an fsync tracer
> 
> fsync() (and its cousin, fdatasync()) are important chokepoints in the
> kernel as they imply very expensive operations, both in terms of filesystem
> operations (ext3 writes back its entire journal) as well as the block layer
> (fsync() implies sending a cache flushing barrier to the SATA/SCSI disk).
> 
> This tracer makes a log of which application calls fsync() on which file,
> so that developers and others interested in finding these choke points
> can locate them and fix them in the apps that call this function.

Sorry, but I have to object to such single purpose tracers..

If we go this way we'll end up with a gazillion little tracers, non of
which are really useful.

Please work on getting something like a syscall tracer, or lttng like
event tracer.

Both of those should be able to find such badness, but are also able to
diagnose many more issues.

Also, sure fsync() is expensive, but you make it sound like its a bad
thing. Lets not teach people to ignore data integrity just because ext3
is such a massive piece of shit.


