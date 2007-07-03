Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbXGCR2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbXGCR2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbXGCR2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:28:41 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:46035 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbXGCR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:28:40 -0400
Message-ID: <468A8733.2060000@nortel.com>
Date: Tue, 03 Jul 2007 13:28:19 -0400
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060130 Red Hat/1.7.12-1.4.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468A724D.6070908@nortel.com> <F1D642E5A91BC94D9504EC83AE19E6B0128A64@ecqcmtlmail3.quebec.int.ec.gc.ca> <468A734C.7030609@nortel.com>
In-Reply-To: <468A734C.7030609@nortel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 17:28:21.0548 (UTC) FILETIME=[8D86C6C0:01C7BD97]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some more information....

I'm trying to get a console on the affected system to query the leap second info 
from the ntp servers.

However, just for kicks I queried the local servers for my desktop following the 
instructions that I found on a thread about spurious leap second notifications. 
  Interestingly, two of the associations show non-zero leap values...

Chris



[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -cas zcars0vr

ind assID status  conf reach auth condition  last_event cnt
===========================================================
   1 62124  b614   yes   yes  none  sys.peer   reachable  1
   2 62125  b4f4   yes   yes  none  candidat   reachable 15
   3 62126  b314   yes   yes  none   outlyer   reachable  1
   4 62127  b314   yes   yes  none   outlyer   reachable  1
   5 62128  8000   yes   yes  none    reject
   6 62129  b434   yes   yes  none  candidat   reachable  3
   7 62130  b424   yes   yes  none  candidat   reachable  2
   8 62131  a0f3   yes   yes  none    reject  lost reach 15


[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62124 leap" zcars0vr
assID=62124 status=b614 reach, conf, sel_sys.peer, 1 event, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62125 leap" zcars0vr
assID=62125 status=b0f4 reach, conf, 15 events, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62126 leap" zcars0vr
assID=62126 status=b314 reach, conf, sel_outlyer, 1 event, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62127 leap" zcars0vr
assID=62127 status=b414 reach, conf, sel_candidat, 1 event, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62128 leap" zcars0vr
assID=62128 status=8000 unreach, conf, no events,
leap=11
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62129 leap" zcars0vr
assID=62129 status=b434 reach, conf, sel_candidat, 3 events, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62130 leap" zcars0vr
assID=62130 status=b424 reach, conf, sel_candidat, 2 events, event_reach,
leap=00
[cfriesen@wcary14e ~]$ /usr/sbin/ntpq -c"rv 62131 leap" zcars0vr
assID=62131 status=a0f3 unreach, conf, 15 events, event_unreach,
leap=11
