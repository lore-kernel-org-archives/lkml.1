Return-Path: <linux-kernel-owner+w=401wt.eu-S938353AbZDJOEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938353AbZDJOEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935889AbZDJOEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:04:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40816 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763852AbZDJOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DrtZoGLFOe2hociZD4AGJtw3apdN4BnZ0K+VoYpFLY7TWciczNwYrHX7mxpdJ7nLV+
         px/1pBvG7WbaJz7T2Nw6G0q9Rdb8lkszQK77fdpWysAd1swyYa+cX9hZPyq1wQ3OIXHt
         ORdlbH2f17HXSteFBTAj5uyxQER2oWqJMldIw=
Message-ID: <49DF51D6.9080000@tuffmail.co.uk>
Date: Fri, 10 Apr 2009 15:04:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [BISECTED] Regression: First hibernation attempt fails
References: <49DDD83F.507@tuffmail.co.uk> <20090410092318.GB30093@elf.ucw.cz> <49DF289D.5070604@tuffmail.co.uk> <20090410112115.GA2513@elf.ucw.cz> <49DF2EE6.20203@tuffmail.co.uk>
In-Reply-To: <49DF2EE6.20203@tuffmail.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Pavel Machek wrote:
>   
>> On Fri 2009-04-10 12:08:13, Alan Jenkins wrote:
>>   
>>     
>>> Pavel Machek wrote:
>>>     
>>>       
>>>> On Thu 2009-04-09 12:13:03, Alan Jenkins wrote:
>>>>   
>>>>       
>>>>         
>>>>> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
>>>>> wonder if it rings any bells?
>>>>>
>>>>> On my laptop (EEE 4G), the first attempt at hibernation fails. 
>>>>> Subsequent attempts succeed.
>>>>>
>>>>> If I use s2disk as normal, I see "snapshotting system", then before it
>>>>> gets to write out the image, it aborts and switches back to X.   I can't
>>>>> see any error message, even if I check the log with "dmesg".
>>>>>
>>>>> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
>>>>> allocate memory".
>>>>>
>>>>> This only happens if I've logged in to X first.  In fact, I narrowed it
>>>>> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
>>>>> then it doesn't happen.
>>>>>         
>>>>>           
>>>> Anything interesting in dmesg?      
>>>>         

>>> Nothing obvious. I've attached my latest at
>>> <http://bugzilla.kernel.org/show_bug.cgi?id=13058>.
>>>       

Bisection succeeded:

1faa16d22877f4839bd433547d770c676d1d964c
"block: change the request allocation/congestion logic to be sync/async
based"

If I revert the commit, it fixes my bug.

Regards
Alan
