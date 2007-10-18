Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXJROdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXJROdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXJROdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:33:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:1402 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJROdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lzjSxniycRp0wfRFUm0U+Sx577etlc4jOPcvmcx9CvVqZOcKBoZMJI/4lowxcCTRohnOc41+l/RwyVyPEf6aGmiSxlFVX095Ff0tvHF1WcCAnj4gnMljtVMR4ngCBUbiVvlvcT12D3R2HnJaRPUfGbcisTSh5q1zkhI5kpPCcBs=
Message-ID: <47176EED.1050801@gmail.com>
Date: Thu, 18 Oct 2007 22:34:21 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       crutcher+kernel@datastacks.com, pavel@ucw.cz, schwab@suse.de
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
 key, try 2
References: <471628D2.8010903@gmail.com> <18386.1192651748@turing-police.cc.vt.edu>
In-Reply-To: <18386.1192651748@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu 写道:
> On Wed, 17 Oct 2007 23:22:58 +0800, Yi Yang said:
>
>   
>> SysRq has already provided a similiar help before this patch, but it
>> is not so clear that the user doesn't know what happened and what
>> he/she should do.
>>     
>
> The person is in one of two states:
>
> 1) He has been told "recreate the problem, hit alt-sysreq-cokebottle,
> and send me the results".  He has a mission, and the only feedback he
> needs is (a) that he hit cokebottle and not pepsibottle, and (b) the
> resulting output.
>
> 2) He's already read the file in Documentation/ and just needs a reminder.
> In this case, the fact it's only 2 or 3 lines and doesn't scroll other stuff
> out of sight is more important.
>   
Screen scroll isn't a problem.

"SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem
Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount
shoW-blocked-tasks"

The above help information isn't very user-friendly.

>   
>> In addition, that funtion has a big loop with another big loop
>> embedded which is very inefficient, it is intended to skip some hot
>>     
>
> You're optimizing code that hopefully never gets executed, and even if
> it does, you have the optimization *backwards*.  If you're worried about
> the efficiency, trim it down to output 3 lines - do you realize how many
> instructions it takes in the VGA and fb drivers to actually *output* all
> these lines? (Seriously - I had a 1.6Ghz P4 laptop, where scrolling the
> screen with vga=791 actually ran so slowly that it horqued up the timer
> initialization code. *That* was a fun bug to figure out..)
>   
To remove a bad loop is just a plus fix. That loop is really inefficient.
>   
>> key help info for such a function as "Changing Loglevel", just print
>> a help info for this, that is very unnecessary. In fact, the key '0'
>>  - '8' have different results the user should know.
>>     
>
> And ironically enough, you then output the same exact text for all levels.
>   
Yes, only one line for them is better.
>
>   
>> +static char __read_mostly sysrq_hot_key_table[36] = {
>> +	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
>> +	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
>> +	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
>> +	'u', 'v', 'w', 'x', 'y', 'z'
>>     
>
> The lists of 'Not defined' tends to scroll the screen away. The old code
> instead focuses on listing the things you *can* do.  If I'm looking at the
> help output, I don't care that 'g' is not defined.  I need to be reminded
> that 'p' is 'showPc' and D is show-all-locks.
>   
You're right, "Not defined" is meaningless for the common users. I'll 
submit a new revision
to fix your concerns.

Thank you very much.

