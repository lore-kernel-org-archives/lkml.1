Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZIUNWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZIUNWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZIUNWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:22:40 -0400
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137]:62021 "EHLO
	nschwmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbZIUNWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:22:40 -0400
Message-ID: <4AB77E21.6020805@bigpond.net.au>
Date: Mon, 21 Sep 2009 23:22:41 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sched: Am I missing something?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx02p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Mon, 21 Sep 2009 13:22:41 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150201.4AB77E22.004A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or is the line:

	p->prio = effective_prio(p);

in wake_up_new_task() an expensive no op.

As far as I can tell from reading the code, it will always be the case 
that EITHER rt_prio(p->prio) is true OR p->prio == p->normal_prio when 
this call is made and, in either case, the value of p->prio will be 
unchanged.  In addition, when this call is made p->normal_prio is 
already equal to to normal_prio(p), so the side effects of the function 
(setting p->normal_prio) are also unnecessary.

Am I correct or have I missed something?

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
