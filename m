Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYEHMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYEHMLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYEHMK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:10:57 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:65027 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYEHMK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:10:56 -0400
Message-ID: <4822EDAD.5010502@cetrtapot.si>
Date: Thu, 08 May 2008 14:10:21 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.12 (X11/20080421)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: time stamped printks
References: <4822B919.5070707@cetrtapot.si> <20080508.020124.232275605.davem@davemloft.net> <4822DF3F.7050506@googlemail.com>
In-Reply-To: <4822DF3F.7050506@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> David Miller wrote:
>> From: Hinko Kočevar <hinko.kocevar@cetrtapot.si>
>> Date: Thu, 08 May 2008 10:26:01 +0200
>>
>>> Hi all,
>>>
>>> I'm building latest GIT tree kernel for CRIS architecture. Right now I'm seeing 
>>> some strange values with printk stamps - at the start they are initialized to 0, 
>>> but quickly change to 42949372 - 0x028F5AFC.
>>>
>>> Any thoughts to where to look for fix?
>> Very early in the boot, the timestamp counter fetching infrastructure
>> isn't setup yet.  So zero is reported for the timestamp.
>>
>> So early on in the boot, it is often not even possible to setup
>> such things yet.  Because infrastructure they need for probing
>> etc. isn't even available yet.
>>
>> This happens on basically every single Linux platform, there
>> isn't really anything to fix.

Hmm, I was under the impression that this was not an issue (at least not in 2.6.25).

> 
> For the early boot 0's it is normal but not for the following strange values :)

I agree.

> 
> I got the same problem on my 64bit box with latest git head and bisected it down to 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
> 
> http://lkml.org/lkml/2008/5/8/146

Well, cris architecture does not have CONFIG_HAVE_UNSTABLE_SCHED_CLOCK. I guess 
sched rework broker something since it was touched by the above commit, or..:

# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set



 From the 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd commit Changelog:
  - architectures that have an 'imperfect' hardware clock can set
    CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

How can one do that? Just add it to the .config?

Regards,
Hinko


-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

