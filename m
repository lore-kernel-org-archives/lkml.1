Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZBYTny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZBYTny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZBYTnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:43:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbZBYTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:43:42 -0500
Date: Wed, 25 Feb 2009 20:46:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org,
       takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
Message-ID: <20090225194615.GE2645@elf.ucw.cz>
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <20090222142327.GF1586@ucw.cz> <200902222327.CIF26085.LOOJVMHQFOFStF@I-love.SAKURA.ne.jp> <20090222144811.GJ1586@ucw.cz> <49A2521E.5030805@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A2521E.5030805@nttdata.co.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-02-23 16:37:02, Toshiharu Harada wrote:
> Pavel Machek wrote:
>> On Sun 2009-02-22 23:27:34, Tetsuo Handa wrote:
>>> Pavel Machek wrote:
>>>> On Thu 2009-02-12 16:34:16, James Morris wrote:
>>>>> On Thu, 5 Feb 2009, Kentaro Takeda wrote:
>>>>>
>>>>>> TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.
>>>>>>
>>>>> Applied to  
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>>>>
>>>> Does that mean tomoyo is scheduled for 2.6.30?
>>>>
>>> TOMOYO is already in linux-next tree and ready to go into 2.6.30 .
>>
>> Last time I looked it included script parser and some
>> interpretter... Was that solved?

>
> Are you talking about the interface between
> userland and kernel regarding string data?

Yes. maybe ioctl() is worse, but I don't think c-like language parser
in kernel is acceptable.

> Linus once said in a Smack thread (http://lkml.org/lkml/2007/11/5/129) 
>>> On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
>>> > Can we avoid string parsers in the kernel?
>>>
>>> Ok, Could someone suggest a better idea please ?. 
>>
>> I personally think string parsers are *much* better than the 
>> alternatives (which basically boil down to nasty binary interfaces)
>>
>>> I thought about packing the rules in a structure and sending
>>> it over an ioctl() command. Is this applicable ?
>>
>> That's *MUCH* worse.
>>
>> Strings are nice. They aren't that complex, and as long as it's not a  
>> performance-critical area, there are basically no downsides.
>>
>> Binary structures and ioctl's are *much* worse. They are totally  
>> undebuggable with generic tools (think "echo" or "strace"), and they 
>> are a total nightmare to parse across architectures and pointer sizes.
>>
>> So the rule should be: always use strings if at all possible and relevant.
>> If the data is fundamentally binary, it shouldn't be re-coded to ascii
>> (no real advantage), but if the data is "stringish", and there aren't
>> big performance issues, then keep it as strings.
>
> Admiring your concern, I would like to follow the above directions.
>
> Best regards,
> Toshiharu Harada

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
