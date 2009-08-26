Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZHZL6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZHZL6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZHZL6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbZHZL6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:58:42 -0400
Message-ID: <4A952370.50603@redhat.com>
Date: Wed, 26 Aug 2009 07:58:40 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
References: <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A9481BE.1030308@redhat.com> <20090826003803.GP4300@elf.ucw.cz> <4A9485A6.1010803@redhat.com> <20090826112121.GD26595@elf.ucw.cz>
In-Reply-To: <20090826112121.GD26595@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 07:21 AM, Pavel Machek wrote:
> On Tue 2009-08-25 20:45:26, Ric Wheeler wrote:
>    
>> On 08/25/2009 08:38 PM, Pavel Machek wrote:
>>      
>>>>>>> I'm not sure what's rare about power failures. Unlike single sector
>>>>>>> errors, my machine actually has a button that produces exactly that
>>>>>>> event. Running degraded raid5 arrays for extended periods may be
>>>>>>> slightly unusual configuration, but I suspect people should just do
>>>>>>> that for testing. (And from the discussion, people seem to think that
>>>>>>> degraded raid5 is equivalent to raid0).
>>>>>>>                
>>>>>> Power failures after a full drive failure with a split write during a rebuild?
>>>>>>              
>>>>> Look, I don't need full drive failure for this to happen. I can just
>>>>> remove one disk from array. I don't need power failure, I can just
>>>>> press the power button. I don't even need to rebuild anything, I can
>>>>> just write to degraded array.
>>>>>
>>>>> Given that all events are under my control, statistics make little
>>>>> sense here.
>>>>>            
>>>> You are deliberately causing a double failure - pressing the power button
>>>> after pulling a drive is exactly that scenario.
>>>>          
>>> Exactly. And now I'm trying to get that documented, so that people
>>> don't do it and still expect their fs to be consistent.
>>>        
>> The problem I have is that the way you word it steers people away from
>> RAID5 and better data integrity. Your intentions are good, but your text
>> is going to do considerable harm.
>>
>> Most people don't intentionally drop power (or have a power failure)
>> during RAID rebuilds....
>>      
> Example I seen went like this:
>
> Drive in raid 5 failed; hot spare was available (no idea about
> UPS). System apparently locked up trying to talk to the failed drive,
> or maybe admin just was not patient enough, so he just powercycled the
> array. He lost the array.
>
> So while most people will not agressively powercycle the RAID array,
> drive failure still provokes little tested error paths, and getting
> unclean shutdown is quite easy in such case.
> 								Pavel
>    

Then what we need to document is do not power cycle an array during a 
rebuild, right?

If it wasn't the admin that timed out and the box really was hung (no 
drive activity lights, etc), you will need to power cycle/reboot but 
then you should not have this active rebuild issuing writes either...

In the end, there are cascading failures that will defeat any data 
protection scheme, but that does not mean that the value of that scheme 
is zero. We need to be get more people to use RAID (including MD5) and 
try to enhance it as we go. Just using a single disk is not a good thing...

ric


Ric

