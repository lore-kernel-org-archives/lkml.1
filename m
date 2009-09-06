Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZIFArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZIFArl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 20:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZIFArk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 20:47:40 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:46168 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZIFArk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 20:47:40 -0400
X-Greylist: delayed 27269 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 20:47:39 EDT
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC481@exchange.ZeugmaSystems.local>
Date: Sat, 5 Sep 2009 17:47:39 -0700
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, Anirban Sinha <ani@anirban.org>
Content-Transfer-Encoding: 7bit
Message-Id: <D0B95E79-EDEC-487A-B8AB-0D90E4E81A9E@anirban.org>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local> <20090905204037.GE4953@gandalf.sssup.it> <DDFD17CC94A9BD49A82147DDF7D545C54DC481@exchange.ZeugmaSystems.local>
To: linux-kernel@vger.kernel.org, fchecconi@gmail.com,
       Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 > You say you pin the threads to a single core: how many cores does  
your
 > system have?

The results I sent you were on a dual core blade.


 > If this is the case, this behavior is the expected one, the scheduler
 > tries to reduce the number of migrations, concentrating the bandwidth
 > of rt tasks on a single core.  With your workload it doesn't work  
well
 > because runtime migration has freed the other core(s) from rt  
bandwidth,
 > so these cores are available to SCHED_OTHER ones, but your  
SCHED_OTHER
 > thread is pinned and cannot make use of them.

But, I ran the same routine on a quadcore blade and the results this  
time were:

rt_runtime/rt_period  % of iterations of reg thrd against rt thrd

0.20                  46%
0.25                  18%
0.26                  7%
0.3                   0%
0.4                   0%
(rest of the cases)   0%

So if the scheduler is concentrating all rt bandwidth to one core, it  
should be effectively 0.2 * 4 = 0.8 for this core. Hence,  we should  
see the percentage closer to 20% but it seems that it's more than  
double. At ~0.25, the regular thread should make no progress, but it  
seems it does make a little progress.
