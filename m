Return-Path: <linux-kernel-owner+w=401wt.eu-S965332AbXCFQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbXCFQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXCFQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:46:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:58839 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332AbXCFQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:46:22 -0500
Message-ID: <45ED9B5B.2030806@tmr.com>
Date: Tue, 06 Mar 2007 11:48:27 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Marc Perkel <mperkel@yahoo.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
References: <Pine.LNX.4.61.0703050430280.23714@yvahk01.tjqt.qr> <382470.25191.qm@web52508.mail.yahoo.com>
In-Reply-To: <382470.25191.qm@web52508.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> --- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
>> On Mar 4 2007 19:17, Marc Perkel wrote:
>>> Thanks - because of your suggestion I had found the
>>> instructions. But you have some interesting options
>>> set. 
>>>
>>> -N nicearray -b internal -e 1.0
>>>
>>> Are these important?
>>   -N? What's in a name? I suppose, it's not so
>> important.
>>   (Arrays are identified by their UUID anyway. But
>> maybe
>>   udev can do something with the name someday as it
>> does
>>   today with /dev/disk/*.)
> 
> Not worth starting over for.
> 
>>   -b internal -- seems like a good idea to speed up
>>   resynchronization.
> 
> I'm trying to figure out what the default is. 
> 
>>   -e 1.0 -- I wonder why the new superblock format
>> is
>>   not default in mdadm (0.90 is still used).
>>
> 
> Looks interesting for big arrays but not sure it's
> worth starting over for. Trying to get through a 2
> hour sync using 4 500gb sata 2 drives.

That's exactly why you want the bitmap. Fortunately you can add it after 
the array is created. Now the bad news, you should read and understand 
the meaning of the "far" layout. Part of the information is in the mdadm 
man page under -p, some in the md man page. Use of "far" layout will 
effect the performance of the array, the balance of read vs. write 
performance, and (maybe) the reliability.

Two hours is a pretty short time to invest if you find that you have 
your layout wrong and would be better off for the life of the array with 
some other data layout. And the time to do the reading is worth if if 
you wind up convinced that the default settings are fine for you.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
