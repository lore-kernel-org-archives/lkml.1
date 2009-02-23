Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZBWINu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZBWINu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZBWINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:13:41 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:35997 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZBWINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:13:40 -0500
X-Greylist: delayed 2185 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 03:13:39 EST
Message-ID: <49A2521E.5030805@nttdata.co.jp>
Date: Mon, 23 Feb 2009 16:37:02 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org,
       takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <20090222142327.GF1586@ucw.cz> <200902222327.CIF26085.LOOJVMHQFOFStF@I-love.SAKURA.ne.jp> <20090222144811.GJ1586@ucw.cz>
In-Reply-To: <20090222144811.GJ1586@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2009 07:37:09.0576 (UTC) FILETIME=[88D92480:01C99589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2009-02-22 23:27:34, Tetsuo Handa wrote:
>> Pavel Machek wrote:
>>> On Thu 2009-02-12 16:34:16, James Morris wrote:
>>>> On Thu, 5 Feb 2009, Kentaro Takeda wrote:
>>>>
>>>>> TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.
>>>>>
>>>> Applied to 
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>>>
>>> Does that mean tomoyo is scheduled for 2.6.30?
>>>
>> TOMOYO is already in linux-next tree and ready to go into 2.6.30 .
> 
> Last time I looked it included script parser and some
> interpretter... Was that solved?
> 									Pavel

Are you talking about the interface between
userland and kernel regarding string data?

Linus once said in a Smack thread (http://lkml.org/lkml/2007/11/5/129) 
>> On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
>> > Can we avoid string parsers in the kernel?
>> 
>> Ok, Could someone suggest a better idea please ?. 
>
> I personally think string parsers are *much* better than the alternatives 
> (which basically boil down to nasty binary interfaces)
>
>> I thought about packing the rules in a structure and sending
>> it over an ioctl() command. Is this applicable ?
>
> That's *MUCH* worse.
>
> Strings are nice. They aren't that complex, and as long as it's not a 
> performance-critical area, there are basically no downsides.
>
> Binary structures and ioctl's are *much* worse. They are totally 
> undebuggable with generic tools (think "echo" or "strace"), and they are a 
> total nightmare to parse across architectures and pointer sizes.
>
> So the rule should be: always use strings if at all possible and relevant.
> If the data is fundamentally binary, it shouldn't be re-coded to ascii
> (no real advantage), but if the data is "stringish", and there aren't
> big performance issues, then keep it as strings.

Admiring your concern, I would like to follow the above directions.

Best regards,
Toshiharu Harada

