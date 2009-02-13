Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZBMFqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZBMFqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZBMFqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:46:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZBMFqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:46:45 -0500
Date: Fri, 13 Feb 2009 00:46:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt/threadirqs: put the irq thread handler in a
 callback
In-Reply-To: <4994f034.02e2660a.3130.23df@mx.google.com>
Message-ID: <alpine.DEB.1.10.0902130046250.15469@gandalf.stny.rr.com>
References: <4994f034.02e2660a.3130.23df@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Feb 2009, Frederic Weisbecker wrote:

> Currently, when a hardirq is threaded, it is processed by do_hardirq()
> which guess the best low-level handler for this irq.
> 
> This makes several branch conditions to check for each irq triggered,
> adding some (very small) latencies since we are in a fastpath (irq disabled)
> of the irq processing.
> 
> So it's better to put these checks only once when the handler of the irq is set
> and then only dereference one pointer to find the appropriate callback.
> 
> This patch makes the irq thread handler a field in struct irq_desc.
> 
> [Note, I'm not sure the check if (!desc->handle_irq_thread) is really
> useful. I've put it to ensure that even an irq_desc which never gone to
> __set_irq_handler() can be handled. But I'm not sure it is possible.]
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks, I'll apply it to my local tree and test it out.

-- Steve

