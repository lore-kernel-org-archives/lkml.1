Return-Path: <linux-kernel-owner+w=401wt.eu-S935679AbYEVKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679AbYEVKek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYEVKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:34:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:42298 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750772AbYEVKe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:34:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+PVb9l7nuPjaLCYYXH3ZIqYRCpkIpS/fLcSk/qlw
	4jY7IoK2hmjWRG
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211447105.4823.7.camel@marge.simson.net>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 22 May 2008 12:34:25 +0200
Message-Id: <1211452465.7606.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 11:05 +0200, Mike Galbraith wrote:
> On Thu, 2008-05-22 at 13:58 +0530, Dhaval Giani wrote:

> > Can you try with 2.6.26-rc? There is minimal load balancing for group
> > scheduling till 25, which might explain the lack of scalability.
> 
> I'm playing with it now, it's tweakable with migration cost.  This
> testcase is funky.  It can't generate enough work to keep CPUs busy for
> spit, and can't saturate my little quad with any kernel I've tried.

Heh, watch this.  No tweaking.  

(Nadia's ipc/idr patches are applied though, to see if the high end
improves over previous runs with various kernels, and it does seem to.)

2.6.26-smp x86_64
1 10014.774797
2 9791.395302
3 10575.369296
4 9763.183251
5 10160.274262
6 9893.174179
8 9566.978464
10 10294.456456
15 9444.100540
20 9137.878618
30 8277.795499
40 7925.824428
50 7646.644285

nail postgres to CPUs1-3
nail pgbench to CPU0

2.6.26-smp x86_64
1 10900.959982
2 15976.870604
3 24661.322669
4 25347.141780
5 25893.815676
6 26756.414839
8 25399.018582
10 26172.878669
15 25542.082746
20 25090.381828
30 24270.301103
40 23405.867336
50 21926.223083



