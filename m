Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXCWCds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXCWCds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 22:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXCWCds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 22:33:48 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:24136 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752665AbXCWCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 22:33:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PfLb09qaaviCz884nV70rBTP8qpPrs86o2+qRVGxqI0PyYYFEj+dMj3olY4t/Pw4V8zhqWiK2w9LsTBuY4UDSC9ZiztnyPUqcVoldeg4GPWha3uEXF94JawgXhDLlNnsjJJpw4/IYNtxxeN9dBHXXKd0FsPSf+yTMB2hQnQhgW8=  ;
X-YMail-OSG: OP2kaFcVM1nsldvcL8oEzloI2PPLToHCADqJ21kp2h0Biu7385cCZru6ZgeT8NnaSpeVzJW8FCqaROqq1Odd5na5UykQ3OztYo2CLEOIVAOE7DWmIFQNR7jI7wkqmwEzu8Mhb_.y4_syIEA-
Message-ID: <46033C85.2010008@yahoo.com.au>
Date: Fri, 23 Mar 2007 13:33:41 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] 2.6.21-rc4 nicksched v32
References: <200703221740.47801.a1426z@gawab.com>
In-Reply-To: <200703221740.47801.a1426z@gawab.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Nick Piggin wrote:

>>Timeslices get scaled by /proc/sys/kernel/base_timeslice. If you have bad
>>interactivity you could try lowering this and see if it helps.
> 
> 
> As I am on 2.6.20, I can't really test this patch, but I tried your sched 
> from PlugSched and its not bad.

OK, the one in plugsched is reasonably different...

> I'm getting strange numbers with chew.c, though.  Try this:
> Boot into /bin/sh
> Run ./chew on one console.
> Run ./chew on another console.
> Watch latencies.
> 
> Console 1:
> pid 671, prio   0, out for  799 ms, ran for  800 ms, load  50%
> pid 671, prio   0, out for  799 ms, ran for  801 ms, load  50%
> pid 671, prio   0, out for  799 ms, ran for  799 ms, load  49%
> pid 671, prio   0, out for  800 ms, ran for  800 ms, load  49%
> 
> Console 2:
> pid 672, prio   0, out for  800 ms, ran for  799 ms, load  49%
> pid 672, prio   0, out for  799 ms, ran for  800 ms, load  50%
> pid 672, prio   0, out for  799 ms, ran for  800 ms, load  50%
> pid 672, prio   0, out for  799 ms, ran for  799 ms, load  49%
> pid 672, prio   0, out for  799 ms, ran for  799 ms, load  49%
> 
> Looks good, but now add a cpu-hog, ie. while :; do :; done
> 
> Console 1:
> 
> pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
> pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
> pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
> pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
> 
> Console 2:
> pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%
> pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%
> pid 672, prio   0, out for 1599 ms, ran for  800 ms, load  33%
> pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%
> 
> It's smooth, but latencies are double on console2.  Easy enough to fix, 
> though, just press scrollock to induce a sleep and then release.

Yeah, this issue is since fixed in v32.

> Also, latencies are huge.  Is there a way to fix latencies per nice?

Latencies should be quite a bit lower in v32. You can lower it
with /proc/sys/kernel/base_timeslice, however I would like to see
whether the current setting gives reasonable interactivity.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
