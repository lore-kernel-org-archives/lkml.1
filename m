Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYELDfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYELDfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYELDf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:35:28 -0400
Received: from mga05.intel.com ([192.55.52.89]:41375 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635AbYELDf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,470,1204531200"; 
   d="scan'208";a="563470106"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: vatsa@linux.vnet.ibm.com
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080512023758.GN3612@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 May 2008 11:33:20 +0800
Message-Id: <1210563200.3151.10.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 08:07 +0530, Srivatsa Vaddagiri wrote:
> On Mon, May 12, 2008 at 09:39:10AM +0800, Zhang, Yanmin wrote:
> > I'm confused by these conceptions.
> 
> Sorry if the recommended options was not clear.
> 
> > Would you like to tell me the exact config options
> > you want to turn on?
> > 
> > Options in my config file(both 2.6.25 and 2.6.26-rc1):
> > 
> > # CONFIG_CGROUPS is not set
> > CONFIG_GROUP_SCHED=y
> > CONFIG_FAIR_GROUP_SCHED=y
> > # CONFIG_RT_GROUP_SCHED is not set
> > CONFIG_USER_SCHED=y
> > # CONFIG_CGROUP_SCHED is not set
> 
> Retain this config for 2.6.25.
> 
> For 2.6.26-rc1, turn OFF CONFIG_USER_SCHED and turn ON CONFIG_CGROUP_SCHED i.e
> 
> # CONFIG_USER_SCHED is not set
> CONFIG_CGROUP_SCHED=y
> 
> [Note that above options are mutually exclusive i.e you cannot set both
> of them to y]
> 
> >From my experiments, results of 2.6.25 (with CONFIG_USER_SCHED=y) are
> same as 2.6.26-rc1 (with CONFIG_CGROUP_SCHED=y).
I tested it with below config against 2.6.26-rc1.

CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set


To make the testing faster, I changed some parameters of volanoMark.
The result of 2.6.26-rc1(﻿CONFIG_CGROUP_SCHED=y) is about 2%~3% less than the one of
2.6.25 (﻿CONFIG_USER_SCHED=y).

-yanmin


