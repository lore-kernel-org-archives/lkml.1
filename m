Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYAPM62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYAPM62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYAPM6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:58:18 -0500
Received: from as2.cineca.com ([130.186.84.242]:46876 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYAPM6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:58:17 -0500
Message-ID: <478DFF62.3070408@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH]
 per-task I/O throttling)
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net> <20080116104541.GB25724@balbir.in.ibm.com>
In-Reply-To: <20080116104541.GB25724@balbir.in.ibm.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 13:58:11 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Andrea Righi <righiandr@users.sourceforge.net> [2008-01-15 17:49:36]:
> 
>> Allow to limit the I/O bandwidth for specific uid(s) or gid(s) imposing
>> additional delays on those processes that exceed the limits defined in a
>> configfs tree.
>>
>> Examples:
>>
>> Limit the I/O bandwidth for user www-data (UID 33) to 4MB/s:
>>
>> root@linux:/config/io-throttle# mkdir uid:33
>> root@linux:/config/io-throttle# cd uid:33/
>> root@linux:/config/io-throttle/uid:33# cat io-rate
>>      io-rate: 0 KiB/sec
>>    requested: 0 KiB
>> last_request: 0 jiffies
>>        delta: 388202 jiffies
>> root@linux:/config/io-throttle/uid:33# echo 4096 > io-rate
>> root@linux:/config/io-throttle/uid:33# cat io-rate
>>      io-rate: 4096 KiB/sec
>>    requested: 0 KiB
>> last_request: 389271 jiffies
>>        delta: 91 jiffies
>>
>> Limit the I/O bandwidth of group backup (GID 34) to 512KB/s:
>>
>> root@linux:/config/io-throttle# mkdir gid:34
>> root@linux:/config/io-throttle# cd gid:34/
>> root@linux:/config/io-throttle/gid:34# cat io-rate
>>      io-rate: 0 KiB/sec
>>    requested: 0 KiB
>> last_request: 0 jiffies
>>        delta: 403160 jiffies
>> root@linux:/config/io-throttle/gid:34# echo 512 > io-rate
>> root@linux:/config/io-throttle/gid:34# cat io-rate
>>      io-rate: 512 KiB/sec
>>    requested: 0 KiB
>> last_request: 403618 jiffies
>>        delta: 80 jiffies
>>
>> Remove the I/O limit for user www-data:
>>
>> root@linux:/config/io-throttle# echo 0 > uid:33/io-rate
>> root@linux:/config/io-throttle# cat uid:33/io-rate
>>      io-rate: 0 KiB/sec
>>    requested: 0 KiB
>> last_request: 419009 jiffies
>>        delta: 568 jiffies
>>
>> or:
>>
>> root@linux:/config/io-throttle# rmdir uid:33
>>
>> Future improvements:
>> * allow to limit also I/O operations per second (instead of KB/s only)
>> * extend grouping criteria (allow to define rules based on process containers,
>>   process command, etc.) 
>>
>> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> 
> Hi, Andrea,
> 
> Thanks for doing this. I am going to review the patches in greater
> detail and also test them. Why do you use configfs when we have a
> control group filesystem available for grouping tasks and providing a
> file system based interface for control and accounting?
> 

Well... I didn't choose configfs for a technical reason, but simply
because I'm more familiar with it, respect to the other equivalent ways
to implement this. But I'll try to look also at the control group
approach, I don't know in details all the advantages/disadvantages, but
it seems interesting anyway.

-Andrea
