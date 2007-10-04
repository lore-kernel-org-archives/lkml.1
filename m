Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXJDQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXJDQHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760248AbXJDP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:58:51 -0400
Received: from mail.tmr.com ([64.65.253.246]:39108 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239AbXJDP6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:58:49 -0400
Message-ID: <47050E79.6020100@tmr.com>
Date: Thu, 04 Oct 2007 12:02:01 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
References: <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu> <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
>>> Changelog since v1:
>>> 1. Added a mutex to serialize directory creation/destruction for a user in
>>>    sysfs
>>> 2. Added a spinlock in the task_group structure to serialize writes to
>>>    tg->shares.
>>> 3. Removed /proc/root_user_cpu_shares.
>>> 4. Added Documentation about the group scheduler.
>> thanks - I have added this to the queue.
>>
>> i'm wondering about the following: could not (yet) existing UIDs be made 
>> configurable too? I.e. if i do this in a bootup script:
>>
>>   echo 2048 > /sys/kernel/uids/500/cpu_share
>>
>> this should just work too, regardless of there not being any UID 500 
>> tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
>> (with the settings in them) should probably not go away either.
> 
> Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs tree,
> generates a uevent and a script then figures out the cpu_share and sets it.
> That way you also don't need to keep the directories. No?

That sounds complex administratively. It means that instead of setting a 
higher or lower than default once and having it persist until reboot I 
have to create a script, which *will* in some cases be left in place 
even after the need has gone.

I agree with Ingo, once it's done it should be persistent.

And as another administrative convenience I can look at that set of 
values and see what shares are being used, even when the user is not 
currently active.

Final question, how do setuid processes map into this implementation?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
