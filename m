Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZDQUmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZDQUmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZDQUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:42:14 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:38994 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZDQUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:42:13 -0400
Date: Fri, 17 Apr 2009 16:34:47 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1239994719.23397.4979.camel@laptop>
Message-ID: <alpine.DEB.1.10.0904171629470.26593@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com>  <1239977776.23397.4590.camel@laptop>  <alpine.DEB.1.10.0904171021360.20239@qirst.com>  <1239979901.23397.4638.camel@laptop>
  <alpine.DEB.1.10.0904171100510.21575@qirst.com>  <20090417153520.GA29968@elte.hu>  <alpine.DEB.1.10.0904171142050.13734@qirst.com>  <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>  <alpine.DEB.1.10.0904171335490.28603@qirst.com> 
 <1239991892.23397.4905.camel@laptop>  <alpine.DEB.1.10.0904171410540.28536@qirst.com> <1239994719.23397.4979.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> > often must occur in parallel on multiple cores. Processing is delayed if
> > any of the cores encounters a delay due to OS noise.
>
> So you have hard deadlines in the order of us? Are these SCHED_FIFO
> tasks or SCHED_OTHER?

SCHED_FIFO has the effect of removing all the involuntary context switches
but it does not effect the other interrutions.

> Your Xeon is a core2 class machine and should have relatively stable
> TSC, however its also a dual socket, which I think defeats the
> stable-ness.

> What clocksource do you have?
>
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource

cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

> Also, looking over the rest of the scheduler tick code, I can't really
> see what would be so expensive.

The expensiveness may be fine if we can limit the number of occurences.
Maybe the histograms for those releases give more insight.

