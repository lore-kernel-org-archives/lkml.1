Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXJXTsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXJXTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXJXTsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:48:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:9865 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbXJXTsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:references:message-id:from:to:in-reply-to:content-type:mime-version:subject:content-transfer-encoding:date:cc:x-mailer;
        b=ImSh4jGddmANABQCoX4ZAoB9V8/IqYZxpmDO7KAiysA8RIbYaRFqRMNZv4vWTg8PXfe8CqwTnMRO0/v25tlET0aFQ4AGTt084ag/wYKeEfs8SSRxs9T6pvpSVQm1BlzDiyb/f0t3Hnms+47E3ei63bZXhOw5vdOIdfG9L90zT50=
References: <471628D2.8010903@gmail.com> <18386.1192651748@turing-police.cc.vt.edu> <47176EED.1050801@gmail.com> <20071018171041.GA4510@elf.ucw.cz>
Message-Id: <D0A3C020-52D3-444B-A75B-9237EE4C2774@gmail.com>
From: Crutcher Dunnavant <crutcher@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20071018171041.GA4510@elf.ucw.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (iPhone Mail 3A109a)
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key, try 2
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2007 11:04:46 -0700
Cc: Yi Yang <yang.y.yi@gmail.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "mj@atrey.karlin.mff.cuni.cz" <mj@atrey.karlin.mff.cuni.cz>,
       "crutcher+kernel@datastacks.com" <crutcher+kernel@datastacks.com>,
       "schwab@suse.de" <schwab@suse.de>
X-Mailer: iPhone Mail (3A109a)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Crutcher Dunnavant

On Oct 18, 2007, at 10:10 AM, Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
>
>>> 1) He has been told "recreate the problem, hit alt-sysreq- 
>>> cokebottle,
>>> and send me the results".  He has a mission, and the only feedback  
>>> he
>>> needs is (a) that he hit cokebottle and not pepsibottle, and (b) the
>>> resulting output.
>>>
>>> 2) He's already read the file in Documentation/ and just needs a  
>>> reminder.
>>> In this case, the fact it's only 2 or 3 lines and doesn't scroll  
>>> other
>>> stuff
>>> out of sight is more important.
>>>
>> Screen scroll isn't a problem.
>>
>> "SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK  
>> showMem
>> Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount
>> shoW-blocked-tasks"
>>
>> The above help information isn't very user-friendly.
>
> Seems perfectly reasonably to me... parhaps "Full" should be replaced
> with "Force-oom"...
>
>>>> In addition, that funtion has a big loop with another big loop
>>>> embedded which is very inefficient, it is intended to skip some hot
>>>>
>>>
>>> You're optimizing code that hopefully never gets executed, and  
>>> even if
>>> it does, you have the optimization *backwards*.  If you're worried  
>>> about
>>> the efficiency, trim it down to output 3 lines - do you realize  
>>> how many
>>> instructions it takes in the VGA and fb drivers to actually  
>>> *output* all
>>> these lines? (Seriously - I had a 1.6Ghz P4 laptop, where  
>>> scrolling the
>>> screen with vga=791 actually ran so slowly that it horqued up the  
>>> timer
>>> initialization code. *That* was a fun bug to figure out..)
>>>
>> To remove a bad loop is just a plus fix. That loop is really
>> inefficient.
>
> No, it is not a fix and no, it is not inefficient.
>
>>>> +static char __read_mostly sysrq_hot_key_table[36] = {
>>>> +    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
>>>> +    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
>>>> +    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
>>>> +    'u', 'v', 'w', 'x', 'y', 'z'
>
> This has to go.
>                                    Pavel

Wow. I've not looked at this in a long time.
A. This imp of sysrq was designed to be run time registerable by  
modules.
B. Some keys aren't valid on some arches.
C. If you care about the lookup time for one table scan, sysrq can't  
help you anyway.
>
> -- d
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
