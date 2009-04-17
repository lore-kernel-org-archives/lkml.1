Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZDQQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZDQQlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbZDQQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:41:08 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:48503 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbZDQQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:41:05 -0400
Date: Fri, 17 Apr 2009 12:33:48 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1239985426.23397.4757.camel@laptop>
Message-ID: <alpine.DEB.1.10.0904171228380.7261@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com>  <1239977776.23397.4590.camel@laptop>  <alpine.DEB.1.10.0904171021360.20239@qirst.com>  <1239979901.23397.4638.camel@laptop>
  <alpine.DEB.1.10.0904171100510.21575@qirst.com>  <20090417153520.GA29968@elte.hu>  <alpine.DEB.1.10.0904171142050.13734@qirst.com> <1239985426.23397.4757.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> As we've constituted, graph 1 is useless.

It certainly shows that the number of >1usec interrupts increases.

> I'm still not quite sure why you couldn't provide the data for the other
> graphs in email. They are not at all that much:

Could have but I thought I better focus on one.

> Graph 2: Noise Length
>
> Kernel          Test 1  Test 2  Test 3  Interruption(AVG)
> 2.6.22          2.55    2.61    1.92    2.36
> 2.6.23          1.33    1.38    1.34    1.35
> 2.6.24          1.97    1.86    1.87    1.90
> 2.6.25          2.09    2.29    2.09    2.16
> 2.6.26          1.49    1.22    1.22    1.31
> 2.6.27          1.67    1.28    1.18    1.38
> 2.6.28          1.27    1.21    1.14    1.21
> 2.6.29          1.44    1.33    1.54    1.44
> 2.6.30-rc2      2.06    1.49    1.24    1.60
>
> Is pretty useless too, since it only counts >1us events. Hence it will
> always be biased.

So what would be useful is to have all the differences in terms of
nanoseconds between measurements? I can just remove the cutoff and then
measure in tenth of usecs. That would be okay?

> You could for example run an NMI profiler at 10000 Hz and collect
> samples. Or use PMU hardware to collect numbers

The point is to have an test apps that can be used to measure OS noise
that may have a variety of causes.

Such a test app needs to be as simple as possible. The TSC loop should be
fine as far as I can tell. Histogram is already there. I can just remove
the 1usec cutoff to get you full details.

