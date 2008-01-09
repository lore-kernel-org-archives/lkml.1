Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYAIUCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYAIUCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYAIUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:01:55 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:59195 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYAIUBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:01:54 -0500
Date: Wed, 9 Jan 2008 22:01:48 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, hch@lst.de, airlied@linux.ie,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       jbeulich@novell.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
Message-ID: <20080109220148.5caebaf1@daedalus.pq.iki.fi>
In-Reply-To: <20080109104149.GB8041@elte.hu>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org>
	<alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie>
	<20080109071945.GB10695@lst.de>
	<20080108.232311.79648776.davem@davemloft.net>
	<20080109104149.GB8041@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 11:41:49 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> i agree. There a few practical complication on x86: the
> do_page_fault() function is currently excluded from kprobe probing,
> for recursion reasons. handle_mm_fault() can be probed OTOH - but
> that does not catch vmalloc()-ed faults. The middle of
> do_page_fault() [line 348] should work better [the point after
> notify_page_fault()] - but it's usually more fragile to insert probes
> to such middle-of-the-function places.

I have been reading about kprobes and one thing particularly bothers me
in the case of mmio-trace. The probe will actually service the page
fault, therefore it should be able force do_page_fault() to return at
the probe point. I could not figure out a way to do that.

Is it possible to do reliably with kprobes or markers?


Thanks for the replies.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
