Return-Path: <linux-kernel-owner+w=401wt.eu-S966174AbXDCN01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966174AbXDCN01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966168AbXDCN01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:26:27 -0400
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:54099 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966046AbXDCN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:26:26 -0400
X-Greylist: delayed 83815 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 09:26:26 EDT
From: dasperry@comcast.net (dave_sperry@ieee.org)
To: Ingo Molnar <mingo@elte.hu>, David Sperry <dave_sperry@ieee.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improved UDP performance using 2.6.21-rc5-rt10
Date: Tue, 03 Apr 2007 13:26:24 +0000
Message-Id: <040320071326.11440.461256000007192600002CB02207300793979D9D0A9F9C0E0B@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: ZGFzcGVycnlAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rt10 shows a big improvement over rt8

##################################################
etup                    Thruput      CPU% 
Nvidia
2.6.21-rc5-rt8           938          65%
   netperf @51
   hardirq @50
   softirq @50

Nvidia
2.6.21-rc5-rt10           938          32%
   netperf @51
   hardirq @50
   softirq @50

very nice for a "work in progress" 

I ran the netperf test a few times and one of the times the netperf test would no longer talk to the server. I had to reboot the rt client to get netperf to talk again. I did have cycle soak running which may have contributed to the problem.

Also when netperf is not running the hard IRQs associated with the NIC use a constant 2% load.


Thanks,
Dave


 -------------- Original message ----------------------
From: Ingo Molnar <mingo@elte.hu>
> 
> * David Sperry <dave_sperry@ieee.org> wrote:
> 
> > > there are a few other things i'm working on to improve this. I've 
> > > uploaded -rt9 which is the current state of affairs. Note that using 
> > > -rt9 you'll likely only see IRQ-8406 overhead in the system, because 
> > > i've added an optimization to do process the softirq-net-tx workload 
> > > in the hardirq thread if the priority of the two is the same (which 
> > > is the default behavior). But -rt9 is still work in progress that is 
> > > not fully finished yet: in some cases i'm seeing 'fluctuating 
> > > performance' problems on forcedeth that werent there before.
> > 
> > I tried -rt9 and saw some odd 'fluctuating performance'. I'll try it 
> > again tomorrow when I am much closer to the box's power button.
> 
> could you try -rt10? I've improved hardirq/softirq threading performance 
> some more, and have tuned the forcedeth driver too.
> 
> 	Ingo

