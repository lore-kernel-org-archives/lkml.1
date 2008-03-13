Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbYCMQWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbYCMQWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYCMQWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:22:44 -0400
Received: from mail.lang.hm ([64.81.33.126]:42132 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYCMQWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:22:43 -0400
Date: Thu, 13 Mar 2008 09:25:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803130216.03230.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803130914320.22040@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803130106.26910.phillips@phunq.net> <alpine.DEB.1.00.0803130133470.22040@asgard.lang.hm> <200803130216.03230.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Daniel Phillips wrote:

> On Thursday 13 March 2008 01:39, david@lang.hm wrote:
>>> Feel free.  You use your script, and somebody with a reliable UPS or
>>> two can use my driver, once it is stabilized of course.  Just don't be
>>> in business against them if being a few milliseconds slower on the
>>> uptake means money lost.
>>
>> so now you are saying that you are faster then a ramdisk?????
>
> No, I am saying that my driver is faster than any script you can write.
> Your script will not be able to give access to data while the ramdisk
> is being populated, nor will it be able to save efficiently exactly
> what is dirty in the ramdisk.  (Explained in my original post if you
> would like to take a look.)

that is not something that makes a difference of a few milliseconds

>> if you have a reliable UPS and are willing to rely on it to save your data
>> take the identical hardware to what you are planning to use, but instead
>> of using your driver just create a ramdisk and load it on boot and save
>> the contents on shutdown.
>
> Aha!  You are getting close.  Really, that is all ramback does.  It
> just handles some very difficult related issues efficiently, in such a
> way as to minimize any denial of service from complete loss of UPS
> power.  This is all just about using power management in a new way that
> gets higher performance.  But your battery power has to be reliable.
> Just make it so.  It is not difficult these days, or even particularly
> expensive.
>
> I calculated somewhere along the line that it would take something like
> 17 minutes to populate the big Violin ramdisk initially, and 17 minutes
> to save it during a loss of line power event, during which UPS power
> must be not run out before ramback achieves disk sync or you will get
> file corruption.  (This rule was mentioned in my original post.)
>
> All well and could, you can in fact do that with a pretty simple script.
> But in the initial 17 minutes your application may not read or write
> the ramdisk data and in the closing 17 minutes it may not write.  That
> knocks your system down to 4 nines, given one planned shutdown per year.
> Not good, not good at all.
>
> See, ramback is entirely about _not_ getting knocked down to 4 nines.
> It wants to stay above 6, given system components that satisfy that goal,
> comprising:
>
>  * Linux
>  * Processor, memory, motherboard etc
>  * Dual power supplies with independent UPS backup
>  * Ramback driver
>
> My proposition is, you can go out and purchase hardware right now that
> delivers 6 nines (30 seconds downtime/year) and yes, it will cost you,
> but if that worries you then set up two (much) cheaper ones and set
> them up as a failover cluster.  (Helps that the Violin box can connect
> via PCI-e to two servers at the same time.)

you just use a redundant system and you no longer care how long it takes 
to shutdown or startup a system. if you're running a datacenter that cares 
about uptime to the point of counting 9's or buying a Violin box you are 
already going to need redundant machines so that you can perform upgrades.

> I say you can do this reliably.  It boils down to your power supplies.
> You say it can't be done.  Who is right?

it also takes the faith that you will never have any unplanned shutdowns, 
since your system will loose massive amounts of data if they happen. 
nobody who worries about 9's will buy into that argument. you achieve 9's 
by figuring that things don't always work, and as a result you figure out 
how to engineer around the failures so that when they happen you stay up. 
manufacturers have been trying to promise that their boxes are so reliable 
that they won't go down for decades, and they haven't suceeded yet.

David Lang
