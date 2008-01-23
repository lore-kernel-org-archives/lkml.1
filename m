Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYAWJYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYAWJYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYAWJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:24:46 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:51142 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYAWJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:24:45 -0500
Date: Wed, 23 Jan 2008 14:54:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [RFC] [PATCH] cgroup: limit network bandwidth
Message-ID: <20080123092417.GA4542@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrea Righi <righiandr@users.sourceforge.net>,
	Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
	LKML <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
References: <47970448.7010609@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47970448.7010609@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 10:09:28]:

> Allow to limit the network bandwidth for specific process containers (cgroups)
> imposing additional delays in the sockets' sendmsg()/recvmsg() calls made by
> those processes that exceed the limits defined in the control group filesystem.
> 
> Example:
>   # mkdir /dev/cgroup
>   # mount -t cgroup -onet net /dev/cgroup
>   # cd /dev/cgroup
>   # mkdir foo
>   --> the cgroup foo has been created
>   # /bin/echo $$ > foo/tasks
>   # /bin/echo 1024 > foo/net.tcp
>   # /bin/echo 2048 > foo/net.tot
>   # sh
>   --> the subshell 'sh' is running in cgroup "foo" that has a maximum network
>       bandwidth for TCP traffic of 1MB/s and 2MB/s for total network
>       activities.
> 
> The netlimit approach can be easily extended to support additional network
> protocols or different socket families or types (PF_UNIX, PF_BLUETOOTH,
> SOCK_SEQPACKET, etc.).
> 
> Signed-off-by: Andrea Righi <a.righi@cineca.it>

Hi, Andrea,

I took a quick look at the patches and it looks like we throttle
network (by forcing a schedule_timeout()), if we exceed our bandwidth
limit. That is one way of doing it, but it has some disadvantages, it
does not scale to 

1. Implementation of soft limits (limit on contention of resource)
   gets harder
2. Why dont use the existing infrastructure for bandwidth limitation
   for implementing the network controller?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
