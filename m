Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZKEI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZKEI5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKEI5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:57:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:45440 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751260AbZKEI5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:57:21 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19z2OUe45hzyOF8gomLiokJiqcFuao65qFwkfgi9C
	8M9NLJ6uFgoKe0
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, alex.shi@intel.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257404598.6406.11.camel@marge.simson.net>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>  <20091103174531.GA14747@elte.hu>
	 <1257299745.16282.49.camel@ymzhang>
	 <1257336461.16163.18.camel@marge.simson.net>
	 <1257387645.16282.66.camel@ymzhang>
	 <1257398417.6401.27.camel@marge.simson.net>
	 <1257404598.6406.11.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 09:57:18 +0100
Message-Id: <1257411438.6497.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 08:03 +0100, Mike Galbraith wrote:
> On Thu, 2009-11-05 at 06:20 +0100, Mike Galbraith wrote:
> > On Thu, 2009-11-05 at 10:20 +0800, Zhang, Yanmin wrote:
> > > On Wed, 2009-11-04 at 13:07 +0100, Mike Galbraith wrote:
> > 
> > > > Can you try the below, and send me 
> > > I tested it on Nehalem machine against the latest tips kernel. netperf loopback
> > > result is good and regression disappears.
> > 
> > Excellent.  Ingo has picked up a version in tip (1b9508f) which has zero
> > negative effect on my x264 testcase, and is a win for mysql+oltp through
> > the whole test spectrum.  As that may (dunno, Ingo?) now be considered a
> > regression fix, ie candidate for 32.final, testing that it does no harm
> > to your big machines would be a good thing.  (pretty please?:)
> 
> Egad. Size XXL difference on my cheap Q6600 box

Ingo, ignore my "eek!" reaction (for now).

I'm trying to test the pull lineup with as many benchmarks as I can fit
in, but methinks I'm screwing this one (unfamiliar) up :-/

> git v2.6.32-rc6-26-g91d3f9b
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
>  65536    4096   60.00     7793073      0    4256.06
>  65536           60.00     7780487           4249.18
> 
> git v2.6.32-rc6-26-g91d3f9b + 1b9508f
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
>  65536    4096   60.00     15133547      0    8264.93
>  65536           60.00     15131466           8263.80
> 
> tip v2.6.32-rc6-1796-gd995f1d
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
>  65536    4096   60.00     13998562      0    7645.08
>  65536           60.00     13986112           7638.28 (uhoh, tinker time.)
> 
> 	-Mike

