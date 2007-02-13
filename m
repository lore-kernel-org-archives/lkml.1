Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXBMUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXBMUX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXBMUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:23:28 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:51011 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXBMUX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:23:27 -0500
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 15:23:27 EST
Message-ID: <45D21771.4090607@mnsu.edu>
Date: Tue, 13 Feb 2007 13:54:25 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Martin A. Fink" <fink@mpe.mpg.de>, Matthias Schniedermeyer <ms@citd.de>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de>	 <200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de>	 <200702131025.15964.fink@mpe.mpg.de> <1171361290.12771.77.camel@laptopd505.fenrus.org>
In-Reply-To: <1171361290.12771.77.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> The problem is: FreeBSD is fast, but lacks of some special drivers. Linux has 
>> all drivers but access to harddisk is unpredictable and thus unreliable!
>> What can I do??
>>     
>
>
> there's several tunables you can do;
> 1) increase /sys/block/<device>/queue/nr_requests
>    the linux default is on the low side
> 2) investigate other elevators; cfq is great for interactive use but not
> so great for max throughput. you can do this by echo'ing "deadline"
> into /sys/block/<device>/scheduler
>   

I'd suggest trying the noop scheduler with your ram based devices.  I 
don't see why these devices would need clever scheduling.  ...but prove 
me wrong if you will.  I haven't tested this.

echo noop > /sys/block/<device>/queue/scheduler

If you don't need journaling EXT2 might be a good choice.  But, I'd also 
like to re-iterate the XFS filesystem recommendation given several times 
now as well.  There are many tunables that /may/ help during filesystem 
creation.  Block size (-b) set to it's maximum would prob. help.

If you're sure you can not encounter power issues:
mount -t xfs -o nobarrier /dev/<device> /mount-point

Here's some more general reading for ya:
Troubleshooting Linux Performance Issues:
http://www.phptr.com/articles/article.asp?p=481867&seqNum=2&rl=1

-- 
Jeffrey Hundstad
