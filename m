Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZCEHab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZCEHab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZCEHaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:30:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCEHaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:30:22 -0500
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
 lightweight local clock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090305011941.GA9821@nowhere>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
	 <20090305011941.GA9821@nowhere>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 08:30:13 +0100
Message-Id: <1236238213.5330.10111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 02:19 +0100, Frederic Weisbecker wrote:

> It takes 1 ms to execute while tracing.
> Considering my frequency is 250 Hz, it means 1/4 of the system is used
> on timer interrupt while tracing.
> 
> For now the hang is fixed, but not the awful latency. And I'm just too frightened
> to test it on 1000 Hz.
> 
> But I plan to add a kind of watchdog to check how many time we spent inside an
> interrupt while graph tracing.
> By checking this time against the current Hz value, I could decide to abort the tracing
> for all irq.

That would basically render the thing useless :-(

Is it specifically function_graph that is so expensive? If so, is that
because of the function exit hook?

