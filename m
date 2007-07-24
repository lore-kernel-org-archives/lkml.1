Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbXGXXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbXGXXd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXGXXdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:33:50 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:54983 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXGXXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:33:49 -0400
Message-ID: <46A68C37.30808@nortel.com>
Date: Tue, 24 Jul 2007 17:33:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: "Li, Tong N" <tong.n.li@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com> <1185310691.7737.40.camel@tongli.jf.intel.com> <46A66A88.8070307@redhat.com> <46A66DB8.4030608@nortel.com> <46A672F8.2040305@redhat.com>
In-Reply-To: <46A672F8.2040305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2007 23:33:19.0953 (UTC) FILETIME=[04AAF410:01C7CE4B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> A fraction of *each* CPU, or a fraction of *total* CPU?  Per-cpu 
> granularity doesn't make anything more fair.

Well, our current solution uses per-cpu weights, because our vendor 
couldn't get the load balancer working accurately enough.  Having 
per-cpu weights and cpu affinity gives acceptable results for the case 
where we're currently using it.

If the load balancer is good enough, per-system weights would be fine. 
It would have to play nicely with affinity though, in the case where it 
makes sense to lock tasks to particular cpus.

> If I have two threads with the same priority, and two CPUs, the 
> scheduler will put one on each CPU, and they'll run happily without any 
> migration or balancing.

Sure.  Now add a third thread.  How often do you migrate?  Put another 
way, over what time quantum do we ensure fairness?

Chris
