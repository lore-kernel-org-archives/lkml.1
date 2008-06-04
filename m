Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbYFDVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbYFDVQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYFDVQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:16:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15584 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYFDVQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:16:25 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3684723"
Message-ID: <4847063B.3030706@qualcomm.com>
Date: Wed, 04 Jun 2008 14:16:43 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	<48447C75.8040203@qualcomm.com>	<200806030156.00155.ioe-lkml@rameria.de>	<4844BB41.7000605@qualcomm.com>	<4845D825.6000403@qualcomm.com>	<20080603194148.56dfebe1.pj@sgi.com>	<48461ADA.8020303@qualcomm.com>	<877id5v1fg.fsf@basil.nowhere.org>	<20080604124126.0d281a99.pj@sgi.com>	<20080604200350.GL20824@one.firstfloor.org>	<20080604151622.a50b984f.pj@sgi.com>	<4846FC21.10304@firstfloor.org> <20080604153819.3a3a5256.pj@sgi.com>
In-Reply-To: <20080604153819.3a3a5256.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Andi wrote:
>> I occasionally recommended it to people because it was much easier
>> to explain than replacing init.
> 
> Definitely ... I'd do the same in such cases.
> 

btw I'm putting together a set of scripts that I call "syspart" (for "system
partitioning") which creates cpusets, sets up IRQ affinity, etc at boot. We
can make your init replacement a part of that package. You could then tell
people to
1. Install syspart rpm
2. Change boot opts to "init=/sbin/syspart par0_cpus=0-3 par0_mems=0-2 par0_init"

The thing will then create /dev/cpuset/par0 with cpus0-3 and mems0-2 and put
/sbin/init into that cpuset.

With the exception of the #1 it's as easy to explain as "isolcpus=".

Paul, I beleive you mentioned a while ago that the tools you guys use for this
aren't open source. Has that changed ? If not I'll write my own. I have all
the scripts ready to go but as you pointed out it has to be a standalone
statically linked binary.

Thanx
Max

