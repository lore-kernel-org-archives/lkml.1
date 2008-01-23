Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYAWPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYAWPmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAWPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:41:52 -0500
Received: from as1.cineca.com ([130.186.84.213]:42241 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYAWPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:41:51 -0500
Message-ID: <4797601D.1050905@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH]
 per-task I/O throttling)
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net> <20080111175847.GA4016@ucw.cz>
In-Reply-To: <20080111175847.GA4016@ucw.cz>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 16:41:18 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-01-15 17:49:36, Andrea Righi wrote:
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
> 
> Maybe ionice from cfq should be improved, instead?

IMHO it would be interesting to have also a way to use the limiting
approach, instead of i/o priority-based only (i.e. checks to ensure that
servicing the requests will not cause the associated user's maximum
quality of service to be exceeded).

see also http://lkml.org/lkml/2008/1/20/157

-Andrea
