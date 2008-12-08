Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYLHGTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYLHGTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYLHGTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:19:46 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:38465 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYLHGTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:19:45 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts
 entry/exit points on outpout
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <493C7058.4060709@gmail.com>
References: <493C7058.4060709@gmail.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 07:19:32 +0100
Message-Id: <1228717172.23742.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 01:54 +0100, Frederic Weisbecker wrote:
> Impact: provide interrupt detection on output
> 
> Suggested by Ingo.
> If a hardirq is raised, we want it to be signaled on output, so this patch
> adds two arrows on the output to find entry and exit points of a hardirq.
> 
> Unfortunately, there are many interrupt entrypoints and these can be differents
> from one arch to another.
> 
> The approach here is one of the easiest, but doesn't shine by its scalability:
> we have an array of the interrupt entrypoints names that we compare with the
> symbol of the current traced function, if it matches, we draw the arrow.
> 
> Ie:
> 
>  1)               |                                unlock_buffer() {
>  1)               |                                  wake_up_bit() {
>  1)               |                                    bit_waitqueue() {
>  1)   0.872 us    |                                      __phys_addr();
>  1)   2.722 us    |                                    }
>  1)               |                                    __wake_up_bit() {
>  1)              ==>                                   __wake_up_bit() {
>  1)               |                                      do_IRQ() {

Would be much nicer, the current proposal is lost when grepping and adds
a weird visual break in the output.

