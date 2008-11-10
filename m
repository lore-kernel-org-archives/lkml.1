Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKJOma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKJOma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYKJOmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:42:21 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:40136 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYKJOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:42:20 -0500
Date: Mon, 10 Nov 2008 08:38:42 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: <1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.64.0811100834500.21257@quilx.com>
References: <1224694989.8431.23.camel@oberon>  <1225132746.14792.13.camel@bobble.smo.corp.google.com>
  <1225219114.24204.37.camel@oberon>  <1225936715.27507.44.camel@bobble.smo.corp.google.com>
  <1225969420.7803.4366.camel@twins>  <Pine.LNX.4.64.0811060900450.3595@quilx.com>
  <1225984098.7803.4642.camel@twins>  <1226015568.2186.20.camel@bobble.smo.corp.google.com>
  <1226053744.7803.5851.camel@twins>  <1226081448.28191.64.camel@bobble.smo.corp.google.com>
 <1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Peter Zijlstra wrote:

> The advantage is that the memory foot-print scales with nr_tasks and the
> runtime cost is min(nr_tasks, nr_cpus) where nr_cpus is limited to the
> cpus the process actually runs on, so this takes full advantage of
> things like cpusets.

Typically you want threads of a process to spread out as far as possible.
The point of having multiple threads is concurrency after all. So this
will deteriorate in the common cases where you want the full aggregate
processing power of a machine to work on something. Timer processing is
already a latency problem (isnt there some option to switch that off?) and
a solution like this is going to make things worse.

Can we at least somehow make sure that nothing significantly happens in a
timer interrupt on a processor if the thread has not scheduled any events
or not odone any system calls?
