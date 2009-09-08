Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbZIHReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbZIHReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZIHReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:34:20 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:51457 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZIHReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:34:19 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <20090906132104.GK14492@gandalf.sssup.it>
Date: Tue, 8 Sep 2009 10:26:29 -0700
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, Anirban Sinha <ASinha@zeugmasystems.com>,
       Dario Faggioli <raistlin@linux.it>
Content-Transfer-Encoding: 7bit
Message-Id: <72BC67CD-0486-4557-8D45-58211311EFE2@anirban.org>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local> <20090905204037.GE4953@gandalf.sssup.it> <DDFD17CC94A9BD49A82147DDF7D545C54DC481@exchange.ZeugmaSystems.local> <D0B95E79-EDEC-487A-B8AB-0D90E4E81A9E@anirban.org> <20090906132104.GK14492@gandalf.sssup.it>
To: Fabio Checconi <fchecconi@gmail.com>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Looking at the git history, there have been several bugfixes to the rt
> bandwidth code from 2.6.26, one of them seems to be strictly related  
> to
> runtime accounting with your setup:
>
>    commit f6121f4f8708195e88cbdf8dd8d171b226b3f858
>    Author: Dario Faggioli <raistlin@linux.it>
>    Date:   Fri Oct 3 17:40:46 2008 +0200
>
>        sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

Hmm. Indeed there did seem to have quite a few fixes to the accounting  
logic. I back-patched our 2.6.26 kernel with the upstream patches that  
seemed relevant and my test code now yields reasonable results.  
Applying the above patch did not fix it though which kind of makes  
sense since from the commit log it seems that the patch fixed cases  
when the RT task was getting *less* CPU than it's bandwidth allocation  
as opposed to more as in my case. I haven't bisected the patchet to  
figure out exactly which one fixed it but I intend to do it later just  
for fun.

For completeness, these are the results after applying the upstream  
patches *and* disabling bandwidth borrowing logic on my 2.6.26 kernel  
running on a quad core blade with CONFIG_GROUP_SCHED turned off (100HZ  
jiffies):

rt_runtime/
rt_period       % of SCHED_OTHER iterations

.40                100%
.50                74%
.60                47%
.70                31%
.80                18%
.90                 8%
.95                4%

--Ani

