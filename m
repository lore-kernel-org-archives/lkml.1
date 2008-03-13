Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYCMIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYCMIh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYCMIhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:37:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:43790 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYCMIhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:37:15 -0400
Date: Thu, 13 Mar 2008 01:39:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803130106.26910.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803130133470.22040@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803130012.36763.phillips@phunq.net> <alpine.DEB.1.00.0803130046190.3786@asgard.lang.hm> <200803130106.26910.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Daniel Phillips wrote:

> On Thursday 13 March 2008 00:55, david@lang.hm wrote:
>> if you are not measuring the time to get from ram to disk (which you are
>> not doing in your ramback device) syncs are meaningless.
>
> There was a time when punchcards ruled and everybody was nervous about
> storing their data on magnetic media.  I remember it well, you may not.
> But you are repeating that bit of history, there is a proverb in there
> somewhere.
>
>>> Why am I reminded of old arguments like "if men were meant to fly, God
>>> would have given them wings"?  Please just give me your microsecond
>>> scale transaction processing solution and I will be impressed and
>>> grateful.  Until then... here is mine.  Service with a smile.
>>
>> if you don't have to worry about unclean shutdowns then your system is not
>> needed. all you need to do is to create a ramdisk that you populate with
>> dd at boot time and save to disk with dd at shutdown. problem solved in a
>> couple lines of shell scripts and no kernel changes needed.
>>
>> if you want the data to be safe in the face of unclean shutdowns and
>> crashes, then you need to figure out how to make the image on disk
>> consistant, and at this point you have basicly said that you don't think
>> that it's a problem. so we're back to what you can do today with a couple
>> lines of scripting.
>
> Feel free.  You use your script, and somebody with a reliable UPS or
> two can use my driver, once it is stabilized of course.  Just don't be
> in business against them if being a few milliseconds slower on the
> uptake means money lost.

so now you are saying that you are faster then a ramdisk?????

either you are completely out of touch or you misunderstood what I was 
saying.

if you have a reliable UPS and are willing to rely on it to save your data 
take the identical hardware to what you are planning to use, but instead 
of using your driver just create a ramdisk and load it on boot and save 
the contents on shutdown.

in this case you are doing zero disk I/O during normal operation, you only 
touch the disk during startup and shutdown.

with your proposal the system will be copying chunks of data from the 
ramdisk to the hard disk at random times, and you are claiming that doing 
so makes you faster then a ramdisk????


I'll say it again. if you trust your UPS and don't care about unclean 
shutdowns (say for example that you trust that linux is just never going 
to crash) there's no need to write parts of the ramdisk to the hard disk 
during normal operation, you can wait until you are told that you are 
going to shutdown to do the data save.

now there's no driver needed, just a couple lines of init scripts.

David Lang


