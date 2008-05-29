Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYE2ROi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYE2ROi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYE2ROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:14:24 -0400
Received: from dsl093-193-175.stl1.dsl.speakeasy.net ([66.93.193.175]:59142
	"EHLO hades.sngx.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbYE2ROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:14:23 -0400
Message-ID: <483EE4A4.20508@sngx.net>
Date: Thu, 29 May 2008 12:15:16 -0500
From: James Cammarata <jimi@sngx.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool - e1000/pcnet32
References: <482DA5B6.1020606@sngx.net>	<482DB46A.8020103@cosmosbay.com>	<482EF192.4070707@sngx.net>	<482F5113.5090703@cosmosbay.com>	<482F610D.2080108@sngx.net>	<20080518003104.GK28241@solarflare.com>	<482FBA09.80201@sngx.net>	<483E0AAE.2020107@sngx.net>	<20080528221118.63da4092.akpm@linux-foundation.org>	<483EA2D1.8050603@sngx.net> <20080529154525.3916c7b5@core>
In-Reply-To: <20080529154525.3916c7b5@core>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For one quite a few of the network cards keep the stats in hardware and
> don't neccessarily have a way to reset them. In other cases there is a
> mix of OS accumulated stats bulk updated by overflow events on the device
> itself.

Yes, and there's no good way to get around that, so the best thing for that 
hardware would probably to not add this functionality, in which case ethtool
would simply report that it's not available.  
 
> Its a lot of complexity, and changes all over the places for the sake of
> a trivial userspace change. I would suggest you instead write a quick bit
> of perl or python that fetches the stats and then updates every second
> with the changes.

I would disagree with you on the complexity issue.  In general, it is one
new function (trivial in length) and an addition to the ethtool ops.  SNMP
and sar cover the reporting needs, but there have been multiple times when
troubleshooting under the gun that this would have been extremely useful
to help diagnose the issue (in one instance, we were getting floods of 
jumbo frames and other errors, and we did not know how quickly they were 
accumulating, because the switch was not seeing the same problem).  My day
job is in the financial industry, so we are often under very short SLA's 
to diagnose issues, and having this built into the kernel/existing tools
would be a boon.  I'd be more than happy to change this to a kernel config
option, experimental and default off for those who would not want it.
