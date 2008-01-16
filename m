Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYAPKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYAPKqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYAPKpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:45:51 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45913 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYAPKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:45:50 -0500
Date: Wed, 16 Jan 2008 16:15:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH]
	per-task I/O throttling)
Message-ID: <20080116104541.GB25724@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrea Righi <righiandr@users.sourceforge.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
	LKML <linux-kernel@vger.kernel.org>
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <478CE41F.5010401@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righiandr@users.sourceforge.net> [2008-01-15 17:49:36]:

> Allow to limit the I/O bandwidth for specific uid(s) or gid(s) imposing
> additional delays on those processes that exceed the limits defined in a
> configfs tree.
> 
> Examples:
> 
> Limit the I/O bandwidth for user www-data (UID 33) to 4MB/s:
> 
> root@linux:/config/io-throttle# mkdir uid:33
> root@linux:/config/io-throttle# cd uid:33/
> root@linux:/config/io-throttle/uid:33# cat io-rate
>      io-rate: 0 KiB/sec
>    requested: 0 KiB
> last_request: 0 jiffies
>        delta: 388202 jiffies
> root@linux:/config/io-throttle/uid:33# echo 4096 > io-rate
> root@linux:/config/io-throttle/uid:33# cat io-rate
>      io-rate: 4096 KiB/sec
>    requested: 0 KiB
> last_request: 389271 jiffies
>        delta: 91 jiffies
> 
> Limit the I/O bandwidth of group backup (GID 34) to 512KB/s:
> 
> root@linux:/config/io-throttle# mkdir gid:34
> root@linux:/config/io-throttle# cd gid:34/
> root@linux:/config/io-throttle/gid:34# cat io-rate
>      io-rate: 0 KiB/sec
>    requested: 0 KiB
> last_request: 0 jiffies
>        delta: 403160 jiffies
> root@linux:/config/io-throttle/gid:34# echo 512 > io-rate
> root@linux:/config/io-throttle/gid:34# cat io-rate
>      io-rate: 512 KiB/sec
>    requested: 0 KiB
> last_request: 403618 jiffies
>        delta: 80 jiffies
> 
> Remove the I/O limit for user www-data:
> 
> root@linux:/config/io-throttle# echo 0 > uid:33/io-rate
> root@linux:/config/io-throttle# cat uid:33/io-rate
>      io-rate: 0 KiB/sec
>    requested: 0 KiB
> last_request: 419009 jiffies
>        delta: 568 jiffies
> 
> or:
> 
> root@linux:/config/io-throttle# rmdir uid:33
> 
> Future improvements:
> * allow to limit also I/O operations per second (instead of KB/s only)
> * extend grouping criteria (allow to define rules based on process containers,
>   process command, etc.) 
> 
> Signed-off-by: Andrea Righi <a.righi@cineca.it>

Hi, Andrea,

Thanks for doing this. I am going to review the patches in greater
detail and also test them. Why do you use configfs when we have a
control group filesystem available for grouping tasks and providing a
file system based interface for control and accounting?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
