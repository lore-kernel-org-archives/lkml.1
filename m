Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXHAWrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXHAWrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbXHAWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:46:56 -0400
Received: from mga05.intel.com ([192.55.52.89]:52746 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753587AbXHAWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,210,1183359600"; 
   d="scan'208";a="275409575"
Subject: Re: [patch] sched: yield debugging
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070731203351.GB21667@elte.hu>
References: <1185573687.19777.44.camel@localhost.localdomain>
	 <20070729173735.GA4041@elte.hu>
	 <1185819052.19777.52.camel@localhost.localdomain>
	 <20070731203351.GB21667@elte.hu>
Content-Type: text/plain
Organization: Intel
Date: Wed, 01 Aug 2007 13:53:37 -0700
Message-Id: <1186001617.19777.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 22:33 +0200, Ingo Molnar wrote:

> ok, good! Could you try the updated debug patch below? I've done two 
> changes: made '1' the default, and added the 
> /proc/sys/kernel/sched_yield_granularity_ns tunable. (available if 
> CONFIG_SCHED_DEBUG=y)
> 
> Could you try to change the yield-granularity tunable and see which 
> value gives the best performance? A value of '100000' should in theory 
> give the current (80% degraded) volanomark performance, the default 
> value should give the above '20% down' result. The question is, is '20% 
> down' the best we can get out of it? Does larger/smaller 
> yield-granularity help perhaps? You can change it to any value between 
> 100 usecs and 1 second.
> 

Turning up the granuality helped.  Here's the data I got
for Volanomark performance relative to 2.6.22
Granuality
1000000000  (max)	9% down
 800000000 		8% down
  80000000		13% down
   8000000  		20% down
    100000		56% down

Tim
