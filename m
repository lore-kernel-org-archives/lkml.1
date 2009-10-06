Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZJFJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZJFJcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZJFJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:32:18 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:45661 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbZJFJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:32:17 -0400
X-Greylist: delayed 1968 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 05:32:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MR+KVSu+t8VE1oPAHgaplXw1WplxuSP3b3hmy57aJBTL69ed50tkMCN4yoc2kvj2+q
         DFyiJzqrKZ2hpFKUCJIG0J5MnyRjWuuVfJ2JOP5FtxZv/QJGd33MJAYJUNX7W9HL2Tm4
         pZHkGfzcHah2mEqLux12riL2pG1CO9Q9wPoNU=
Message-ID: <4ACB06C8.9030209@tuffmail.co.uk>
Date: Tue, 06 Oct 2009 09:58:48 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
References: <4AC8B4A8.3050601@tuffmail.co.uk> <4ACA50DD.9050801@tuffmail.co.uk> <4ACA5E3D.1020108@tuffmail.co.uk> <200910060048.41615.rjw@sisk.pl>
In-Reply-To: <200910060048.41615.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 05 October 2009, Alan Jenkins wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> Stefan Seyfried wrote:
>>>       
>>>> On Sun, 4 Oct 2009 22:47:43 +0200
>>>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>>>         
>>>>> On Sunday 04 October 2009, Alan Jenkins wrote:
>>>>>           
>>>>>> Alan Jenkins wrote:
>>>>>>             
>>>>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation. 
>>>>>>> Sometimes they cause a hang during resume; sometimes they happen
>>>>>>> just after resume. It doesn't happen all the time either - I've
>>>>>>> just hibernated three times in a row with no problems. It's most
>>>>>>> perplexing.
>>>>>>>               
>>>>> As I already asked in the Bugzilla, can you verify that this is
>>>>> reproducible without KMS?
>>>>>           
>>> No. I couldn't reproduce it without KMS. Then I re-enabled KMS, 
>>> hibernated a couple of times, and had another resume hang (different 
>>> again - this time in the freezer).
>>>
>>>       
>> Perhaps this GEM backtrace is more relevant than the others, or perhaps 
>> not. I closed the lid during resume from hibernation; the screen stayed 
>> black when I re-opened it, but syslogd recorded the following. (Again, 
>> I've done the exact thing before and often nothing unusual happens) -
>>     
>
> OK, let's assume it's related to KMS, then.
>
> 1. Do we already have a Bugzilla entry for it?
> 2. Did it work with 2.6.31 (and with KMS)?
>   

I thought so, but my recollection is hazy.  I didn't test it for very
long if I did.  I've tried it now and 2.6.31 behaves pretty similarly. 
Sorry for ringing the regression bell.

Firstly the _hibernation_ process hung (after a couple of suspend-to-ram
cycles).

No text on the console (despite using s2disk).  It echoed keypresses and
responds to SysRq keys.  No messages from lockdep or the hung task
detector (after waiting 5 minutes).  SysRq-P said we're in the idle
loop; SysRq-T said both events/0 and hald-addon-input were runnable.

Then suspend-to-ram hung (following a hibernation cycle).  This time it
showed the contents of vt1, but didn't appear to respond to anything
short of SysRq+B.


> 3. Are you aware of http://marc.info/?l=linux-kernel&m=125452324520623&w=4 ?
>
> Thanks,
> Rafael
>   

I guess there's no connection.  That issue seems to be about generally
flickery screens.  I've seen a few rare flickers that might be related. 
But in general nothing bad happens until I try to suspend, and the
badness is in the form of random crashes or hangs.

Also that bug is confirmed to be a regression, and my issue isn't :-).

Many thanks
Alan
