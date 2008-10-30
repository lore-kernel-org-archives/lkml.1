Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJ3Ua1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJ3Ua1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYJ3UaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:30:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYJ3UaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:30:14 -0400
Date: Thu, 30 Oct 2008 16:30:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
In-Reply-To: <490A08E3.2040201@gmail.com>
Message-ID: <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com>
References: <490A08E3.2040201@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Frederic Weisbecker wrote:
> 
> So the idea is to allocate a general set of slots on which we can save our original
> return address and the call time. After that we change the return address of the
> hooked function to jump on a trampoline which will push the offset for us
> to retrieve the slot on the set for this function call. Then the trampoline
> will call a return handler that will trace the return time and send all of these
> informations to a specific tracer. And then the return handler will return to the
> original return address.
> 
> To determine quickly which slot is free, I use a bitmap of 32 bits. 
> Perhaps it is a bad assumption but I could enlarge it and there is an overrun
> counter. This is the only point which needs to be protected against 
> concurrent access.
> 


What about storing the return addresses on the bottom of the stack?
That is, start at task->stack + sizeof(thread_info), and stack up on that. 
Be careful, there might already be users of that area. This will also need 
to be arch dependent.

Note, more is needed than what I wrote above, I'm just suggesting another 
approach.

-- Steve

