Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZFVRGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZFVRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFVRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:05:53 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:25962
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbZFVRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:05:52 -0400
X-IronPort-AV: E=Sophos;i="4.42,269,1243807200"; 
   d="scan'208";a="29979087"
Message-ID: <4A3FBA11.8030304@inria.fr>
Date: Mon, 22 Jun 2009 19:06:25 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>	 <87zldjn597.fsf@basil.nowhere.org>	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>	 <20090612103251.GJ25568@one.firstfloor.org>	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>	 <1245119977.6724.40.camel@lts-notebook>	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>	 <1245164395.15138.40.camel@lts-notebook>	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>	 <1245299856.6431.30.camel@lts-notebook>  <4A3F7A49.6070805@inria.fr>	 <1245680649.7799.54.camel@lts-notebook>  <4A3FA326.8030802@inria.fr> <1245689724.7799.124.camel@lts-notebook>
In-Reply-To: <1245689724.7799.124.camel@lts-notebook>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:
> The primary difference should be at unmap time, right?  In the fault
> path, I only update the pte of the faulting task.  That's why I require
> the [anon] pages to be in the swap cache [or something similar].  I
> don't want to be fixing up other tasks' page tables in the context of
> the faulting task's fault handler.  If, later, another task touches the
> page, it will take a minor fault and find the [possibly migrated] page
> in the cache.  Hmmm, I guess all tasks WILL incur the minor fault if
> they touch the page after the unmap.  That could be part of the
> difference if you compare on the same kernel version.
>   

Agreed.

> Try booting with cgroup_disable=memory on the command line, if you have
> the memory resource controller configured in.  See what that does to
> your measurements.
>   

It doesn't seem to help. I'll try to bisect and find where the
performance dropped.

> ??? I would expect low level page copying to be highly optimized per
> arch, and also fairly stable.

I just did a quick copy_page benchmark and didn't see any performance
difference between 2.6.27 and mmotm.

thanks,
Brice

