Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZANSTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZANSTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZANSTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:19:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63578 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZANSTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:19:43 -0500
Date: Wed, 14 Jan 2009 13:19:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: reset write when reserve buffer fail
In-Reply-To: <496AB3AA.4060005@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0901141259510.15549@gandalf.stny.rr.com>
References: <496AB3AA.4060005@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Lai,

Sorry for the late response, I've got a million things going on at once, 
and this needed more thought than a quick review.

On Mon, 12 Jan 2009, Lai Jiangshan wrote:

> 
> Impact: reset struct buffer_page.write when interrupt storm
> 
> if struct buffer_page.write is not reset, any succedent committing
> will corrupted ring_buffer:
> 
> static inline void
> rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
> {
> 	......
> 		cpu_buffer->commit_page->commit =
> 			cpu_buffer->commit_page->write;
> 	......
> }
> 
> 
> when "if (RB_WARN_ON(cpu_buffer, next_page == reader_page))", ring_buffer
> is disabled, but some reserved buffers may haven't been committed.
> we need reset struct buffer_page.write.

So what you are saying is, when we hit this anomaly, another cpu might be 
writing to the ring buffer, and will soon do a commit.

> 
> when "if (unlikely(next_page == cpu_buffer->commit_page))", ring_buffer
> is still available, we should not corrupt it.

OK, makes sense. I'll queue it up.

Thanks!

-- Steve
