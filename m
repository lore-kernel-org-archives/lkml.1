Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbXJRRKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbXJRRKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764183AbXJRRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:10:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45429 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbXJRRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:10:38 -0400
Date: Thu, 18 Oct 2007 19:10:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Yi Yang <yang.y.yi@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, akpm@osdl.org,
       mj@atrey.karlin.mff.cuni.cz, crutcher+kernel@datastacks.com,
       schwab@suse.de
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
	key, try 2
Message-ID: <20071018171041.GA4510@elf.ucw.cz>
References: <471628D2.8010903@gmail.com> <18386.1192651748@turing-police.cc.vt.edu> <47176EED.1050801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47176EED.1050801@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> 1) He has been told "recreate the problem, hit alt-sysreq-cokebottle,
>> and send me the results".  He has a mission, and the only feedback he
>> needs is (a) that he hit cokebottle and not pepsibottle, and (b) the
>> resulting output.
>>
>> 2) He's already read the file in Documentation/ and just needs a reminder.
>> In this case, the fact it's only 2 or 3 lines and doesn't scroll other 
>> stuff
>> out of sight is more important.
>>   
> Screen scroll isn't a problem.
>
> "SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem
> Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount
> shoW-blocked-tasks"
>
> The above help information isn't very user-friendly.

Seems perfectly reasonably to me... parhaps "Full" should be replaced
with "Force-oom"...

>>> In addition, that funtion has a big loop with another big loop
>>> embedded which is very inefficient, it is intended to skip some hot
>>>     
>>
>> You're optimizing code that hopefully never gets executed, and even if
>> it does, you have the optimization *backwards*.  If you're worried about
>> the efficiency, trim it down to output 3 lines - do you realize how many
>> instructions it takes in the VGA and fb drivers to actually *output* all
>> these lines? (Seriously - I had a 1.6Ghz P4 laptop, where scrolling the
>> screen with vga=791 actually ran so slowly that it horqued up the timer
>> initialization code. *That* was a fun bug to figure out..)
>>   
> To remove a bad loop is just a plus fix. That loop is really
> inefficient.

No, it is not a fix and no, it is not inefficient.

>>> +static char __read_mostly sysrq_hot_key_table[36] = {
>>> +	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
>>> +	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
>>> +	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
>>> +	'u', 'v', 'w', 'x', 'y', 'z'

This has to go.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
