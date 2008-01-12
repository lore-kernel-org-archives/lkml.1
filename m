Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYALSBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYALSBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYALSB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:01:28 -0500
Received: from as2.cineca.com ([130.186.84.242]:58980 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYALSB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:01:26 -0500
Message-ID: <4789006C.2030804@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net>	 <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>	 <47879A32.8060508@users.sourceforge.net>	 <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy>	 <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy>
In-Reply-To: <1200136245.7999.20.camel@lappy>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Jan 2008 19:01:14 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2008-01-12 at 16:27 +0530, Balbir Singh wrote:
>> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-01-12 10:46:37]:
>>
>>> On Fri, 2008-01-11 at 23:57 -0500, Valdis.Kletnieks@vt.edu wrote:
>>>> On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:
>>>>
>>>>> The interesting feature is that it allows to set a priority for each
>>>>> process container, but AFAIK it doesn't allow to "partition" the
>>>>> bandwidth between different containers (that would be a nice feature
>>>>> IMHO). For example it would be great to be able to define per-container
>>>>> limits, like assign 10MB/s for processes in container A, 30MB/s to
>>>>> container B, 20MB/s to container C, etc.
>>>> Has anybody considered allocating based on *seeks* rather than bytes moved,
>>>> or counting seeks as "virtual bytes" for the purposes of accounting (if the
>>>> disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
>>>> of data)?
>>> I was considering a time scheduler, you can fill your time slot with
>>> seeks or data, it might be what CFQ does, but I've never even read the
>>> code.
>>>
>> So far the definition of I/O bandwidth has been w.r.t time. Not all IO
>> devices have sectors; I'd prefer bytes over a period of time.
> 
> Doing a time based one would only require knowing the (avg) delay of
> seeks, whereas doing a bytes based one would also require knowing the
> (avg) speed of the device.
> 
> That is, if you're also interested in providing a latency guarantee.
> Because that'd force you to convert bytes to time again.

So, what about considering both bytes/sec and io-operations/sec? In this
way we should be able to limit huge streams of data and seek storms (or
any mix of them).

Regarding CFQ, AFAIK it's only possible to configure an I/O priorty for
a process, but there's no way for example to limit the bandwidth (or I/O
operations/sec) for a particular user or group.

-Andrea
