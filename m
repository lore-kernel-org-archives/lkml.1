Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbYEVL0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbYEVL0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYEVLZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:25:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:45525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752554AbYEVLZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:25:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/GYWpKiQbG+Vwp19OROJtpHxoj3BS/IVYMnKKIXb
	FHKVGl3QXlHtXv
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211452465.7606.8.camel@marge.simson.net>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 22 May 2008 13:25:53 +0200
Message-Id: <1211455553.4381.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 12:34 +0200, Mike Galbraith wrote:

> (Nadia's ipc/idr patches are applied though, to see if the high end
> improves over previous runs with various kernels, and it does seem to.)

Disregard the above, no they don't.  (now removed again)

However.  The problem with 2.6.26.git running this testcase appears to
be SYNC_WAKEUPS. No taskset, nada except echo 863 > sched_features
 
2.6.26.git
1 8173.538610
2 15738.206889
3 23399.356839
4 21401.182501
5 21682.839897
6 26396.301413
8 29910.334798
10 29953.625797
15 29535.740343
20 28950.900431
30 27159.733949
40 24163.344207
50 23258.496794

vs

2.6.22.17-0.1-default (opensuse 10.3 stock kernel)
1 7693.501369
2 15669.304960
3 25340.818410
4 24445.932930
5 22807.019544
6 24051.387364
8 22406.392813
10 22631.510576
15 21225.243584
20 20382.232075
30 18834.814588
40 17799.906622
50 17305.274561

