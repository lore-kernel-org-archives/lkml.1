Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZIGAlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZIGAlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 20:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbZIGAlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 20:41:49 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:61073 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbZIGAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 20:41:48 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <1252249790.13541.28.camel@marge.simson.net>
Date: Sun, 6 Sep 2009 17:41:47 -0700
Cc: Anirban Sinha <ASinha@zeugmasystems.com>,
       Lucas De Marchi <lucas.de.marchi@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
Message-Id: <71F08B76-1EC2-4868-BFF5-944B3F83A9F1@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <1252232289.29247.11.camel@marge.simson.net> <DDFD17CC94A9BD49A82147DDF7D545C54DC482@exchange.ZeugmaSystems.local> <1252249790.13541.28.camel@marge.simson.net>
To: Mike Galbraith <efault@gmx.de>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-09-06, at 8:09 AM, Mike Galbraith wrote:

> On Sun, 2009-09-06 at 07:53 -0700, Anirban Sinha wrote:
>>
>>
>>
>>> Seems kjournald can end up depending on kblockd/3, which ain't
>>> going anywhere with that 100% RT hog in the way,
>>
>> I think in the past AKPM's response to this has been "just don't do
>> it", i.e, don't hog the CPU with an RT thread.
>
> Oh yeah, sure.  Best to run RT oinkers on isolated cpus.

Correct. Unfortunately at some places, the application coders do  
stupid things and then the onus falls on the kernel guys to make  
things 'just work'.

I would not have any problems if such a cap mechanism did not exist at  
all. However, since we do have such a tuning knob. I would say that  
let's make it do what it is supposed to do. In the documentation it  
says  "0.05s to be used by SCHED_OTHER". Unfortunately, it never hints  
that if your thread is tied to the RT core, you are screwed. The  
bandwidth accumulation logic would virtually kill all the remaining  
SCHED_OTHER threads, much before that 95% cap is reached. Somewhere it  
doesn't quite seem right. At the very very least, can we have this  
clearly written in sched-rt-group.txt?

Cheers,

Ani

  
