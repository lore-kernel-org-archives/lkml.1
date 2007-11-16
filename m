Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXKPKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXKPKsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXKPKsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:48:03 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41076 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbXKPKsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:48:02 -0500
Date: Fri, 16 Nov 2007 02:48:01 -0800
From: Micah Dowty <micah@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071116104801.GA4585@vmware.com>
References: <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116060700.GD16273@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 07:07:00AM +0100, Ingo Molnar wrote:
> 
> * Micah Dowty <micah@vmware.com> wrote:
> 
> > > I am a bit at a loss as to how this could relate to the patch. This 
> > > looks like a load balance logic issue that causes the load 
> > > calculation to go wrong?
> > 
> > My best guess is that this has something to do with the timing with 
> > which we sample the CPU's instantaneous load when calculating the load 
> > averages.. but I still understand only the basics of the scheduler and 
> > SMP balancer. All I really know for sure at this point regarding your 
> > patch is that git-bisect found it for me.
> 
> hm, your code uses timeouts for this, right? The CPU load average that 
> is used for SMP load balancing is sampled from the scheduler tick - and 
> has been sampled from the scheduler tick for eons. v2.6.23 defaulted to 
> a different method but v2.6.24 samples it from the tick again. So my 
> guess is, your testcode behave similarly on 2.6.22 too, correct?

Interesting.. here are the kernels I've tested so far, not including
the git-bisect run I did between 2.6.19 and 2.6.20:

2.6.17 -
2.6.19 -
2.6.19.7 -
2.6.20 +
2.6.21 +
2.6.22 -
2.6.23.1 +

Here a "-" means that the problem does not occur (my test program uses
100% of both CPUs) and a "+" means that the test program leaves one
CPU mostly idle.

Unless I've made a mistake, 2.6.22 seems like the outlier rather than
2.6.23. Is this inconsistent with the scheduler tick hypothesis?

Thanks,
--Micah
