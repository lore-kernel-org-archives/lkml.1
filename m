Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZHRM7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZHRM7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZHRM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:59:12 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:48973 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbZHRM7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:59:11 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
	 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 14:59:08 +0200
Message-Id: <1250600348.7583.280.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 13:49 +0100, Metzger, Markus T wrote:
> Hi Ingo, Peter,
> 
> Did you say that branch tracing is working for you?
> 
> On my system, the kernel hangs.
> 
> Could it be that it simply takes too long to copy the trace? When I set the number
> of samples to 10, everything seems to work OK. When I increase that number to 1000,
> the kernel is getting very slow and eventually hangs.
> 
> I get a message "hrtimer: interrupt too slow", and I get a soft lockup bug. The rest
> of the message log seems pretty garbled.
> 
> In that case, I should probably defer the perf_counter_output() and simply switch
> buffers in the interrupt handler. This would use twice as much locked memory, though, and
> it will likely lose trace when tracing kernel branches. I would further need to make
> sure that the counter does not go away when I do the perf_counter_output(). If possible,
> I should also stall the task until its trace has been processed.
> 
> All in all, it adds complexity and makes the feature more expensive. If you think that
> this could cause the problem of the hanging kernel, I would give it a try.
> 
> 
> One more thing, Peter's patch seems to make the problem appear much more reliably
> than before. Without the patch, I only got the kernel hang when I ran perf top
> in the background. Now, the kernel hangs for every perf record that uses branch
> tracing. This could give another hint to the problem, but I did not find anything
> when I looked at the patch. Do you have any idea, Peter?

Not much, I don't appear to have a single system with serial output (or
another reliable console) that has BTS hardware.

