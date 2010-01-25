Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983Ab0AYVwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0AYVwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454Ab0AYVwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:52:11 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:53261 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039Ab0AYVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:52:09 -0500
Message-ID: <4B5E1281.7090700@suse.de>
Date: Tue, 26 Jan 2010 00:52:01 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Update][PATCH] MM / PM: Force GFP_NOIO during suspend/hibernation
 and resume
References: <201001212121.50272.rjw@sisk.pl> <201001222219.15958.rjw@sisk.pl> <1264238962.16031.4.camel@maxim-laptop> <201001252249.18690.rjw@sisk.pl>
In-Reply-To: <201001252249.18690.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki пишет:
> On Saturday 23 January 2010, Maxim Levitsky wrote:
>> On Fri, 2010-01-22 at 22:19 +0100, Rafael J. Wysocki wrote: 
>>> On Friday 22 January 2010, Maxim Levitsky wrote:
>>>> On Fri, 2010-01-22 at 10:42 +0900, KOSAKI Motohiro wrote: 
>>>>>>>> Probably we have multiple option. but I don't think GFP_NOIO is good
>>>>>>>> option. It assume the system have lots non-dirty cache memory and it isn't
>>>>>>>> guranteed.
>>>>>>> Basically nothing is guaranteed in this case.  However, does it actually make
>>>>>>> things _worse_?  
>>>>>> Hmm..
>>>>>> Do you mean we don't need to prevent accidental suspend failure?
>>>>>> Perhaps, I did misunderstand your intention. If you think your patch solve
>>>>>> this this issue, I still disagree. but If you think your patch mitigate
>>>>>> the pain of this issue, I agree it. I don't have any reason to oppose your
>>>>>> first patch.
>>>>> One question. Have anyone tested Rafael's $subject patch? 
>>>>> Please post test result. if the issue disapper by the patch, we can
>>>>> suppose the slowness is caused by i/o layer.
>>>> I did.
>>>>
>>>> As far as I could see, patch does solve the problem I described.
>>>>
>>>> Does it affect speed of suspend? I can't say for sure. It seems to be
>>>> the same.
>>> Thanks for testing.
>> I'll test that too, soon.
>> Just to note that I left my hibernate loop run overnight, and now I am
>> posting from my notebook after it did 590 hibernate cycles.
> 
> Did you have a chance to test it?
> 
>> Offtopic, but Note that to achieve that I had to stop using global acpi
>> hardware lock. I tried all kinds of things, but for now it just hands
>> from time to time.
>> See http://bugzilla.kernel.org/show_bug.cgi?id=14668
> 
> I'm going to look at that later this week, although I'm not sure I can do more
> than Alex about that.
> 
> Rafael
Rafael,
If you can point to where one may insert callback to be called just before handing control to resume kernel,
it may help...

Regards,
Alex.



