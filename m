Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbZDQOhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbZDQOhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZDQOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:36:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:33912 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZDQOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:36:54 -0400
Date: Fri, 17 Apr 2009 10:29:35 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1239977776.23397.4590.camel@laptop>
Message-ID: <alpine.DEB.1.10.0904171021360.20239@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> If you want to measure something I'd suggest making a histogram of tsc
> values in 10ns buckets or something, and seeing if there are a few
> predominant spikes above the noise.

See
http://www.kernel.org/pub/linux/kernel/people/christoph/collab-spring-2009/Latencharts.ods
for more details. The tool we are using can produce histograms but they
were too voluminous to be included.

> With something like that you could say, the jiffy tick went from 0.8+-.1
> to 1.1+-.1 us or somesuch.

Well yeah we can look at this but there seem to be regressions in a lot of
other subsystems as well. Rescheduling is another thing that we tracked.
Its interesting that the holdoffs varied at lot during the scheduler
transition to CFS and then stayed high after that was complete.

> After that, you could possibly use oprofile or readprofile or
> perf-counters to get an idea where the time is spend. I did a quick
> profile on one of my machines, and about half the kernel time spend in a
> while(1) loop comes from __do_softirq().
>
> Really, I should not have to tell you this...

I can get down there but do you really want me to start hacking on the
scheduler again? This seems to be a regression from what we had working
fine before.
