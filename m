Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXCWGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXCWGFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422627AbXCWGFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:05:52 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:42209 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXCWGFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:05:51 -0400
Date: Fri, 23 Mar 2007 07:05:31 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs q [was: sysfs ugly timer interface]
In-Reply-To: <20070323044823.GA8881@kroah.com>
Message-ID: <Pine.LNX.4.61.0703230700030.9555@yvahk01.tjqt.qr>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org>
 <200703180100.01889.maximlevitsky@gmail.com> <20070320115403.GA3983@ucw.cz>
 <20070322152842.GA6054@kroah.com> <Pine.LNX.4.61.0703230221350.9555@yvahk01.tjqt.qr>
 <20070323044823.GA8881@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22 2007 21:48, Greg KH wrote:
>On Fri, Mar 23, 2007 at 02:24:46AM +0100, Jan Engelhardt wrote:
>> On Mar 22 2007 08:28, Greg KH wrote:
>> 
>> Question regarding sysfs files: How would you do something like 
>> /proc/net/nf_conntrack with sysfs? Have directories named like 0000, 
>> 0001, 0002, ..?
>
>I don't know, I've never said that _all_ proc files can move to sysfs. 
>For some things, like possibly the netfilter stuff, proc files make 
>more sense.

But proc is for procs. (At least its name indicates.)

>Were you thinking of moving this file to sysfs?

No, not that one. But new modules. Everyone says "please no new /proc 
files"[some examples, 1,2]. On the other hand,

[1] http://lkml.org/lkml/2007/1/21/34
[2] http://lkml.org/lkml/2005/2/3/285

>>>> root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered                         
>>>> lapic                F:0007 M:3(periodic) C: 1
>>>> hpet                 F:0003 M:1(shutdown) C: 0
>>>> lapic                F:0007 M:3(periodic) C: 0
>>>> root@MAIN:/home/maxim#
>>>                                                                            
>>> Now... this file needs to die, before 2.6.21 is released. It tries to
>>> bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
>>> part of stable ABI!

when there's a proc-style multi-line file like that clockevents thing in 
sysfs, people raise objections too (see above), which leads me to the 
question: if neither procfs nor sysfs are appropriate for such files, 
what is?


>What does the information in it represent?

A list of the currently tracked connections.



Jan
-- 
