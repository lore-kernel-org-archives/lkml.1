Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZCXLKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZCXLKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZCXLKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:10:45 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:46003 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbZCXLKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:10:44 -0400
Message-ID: <49C8BF95.504@krogh.cc>
Date: Tue, 24 Mar 2009 12:10:13 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Rees <drees76@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <20090324081659.GA9730@elte.hu>
In-Reply-To: <20090324081659.GA9730@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jesper Krogh <jesper@krogh.cc> wrote:
> 
>> David Rees wrote:
>>> On Mon, Mar 23, 2009 at 11:19 PM, Jesper Krogh <jesper@krogh.cc> wrote:
>>>> I know this has been discussed before:
>>>>
>>>> [129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 480
>>>> seconds.
>>> Ouch - 480 seconds, how much memory is in that machine, and how slow
>>> are the disks? 
>> The 480 secondes is not the "wait time" but the time gone before 
>> the message is printed. It the kernel-default it was earlier 120 
>> seconds but thats changed by Ingo Molnar back in september. I do 
>> get a lot of less noise but it really doesn't tell anything about 
>> the nature of the problem.
> 
> That's true - the detector is really simple and only tries to flag 
> suspiciously long uninterruptible waits. It prints out the context 
> it finds but otherwise does not try to go deep about exactly why 
> that delay happened.
> 
> Would you agree that the message is correct, and that there is some 
> sort of "tasks wait way too long" problem on your system?

The message is absolutely correct (it was even at 120s).. thats too long
for what I consider good.

> Considering:
> 
>> The systes spec:
>> 32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in  
>> Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to  
>> decide if thats fast or slow?
> [...]
>> Yes, I've hit 120s+ penalties just by saving a file in vim.
> 
> i think it's fair to say that an almost 10 minutes uninterruptible 
> sleep sucks to the user, by any reasonable standard. It is the year 
> 2009, not 1959.
> 
> The delay might be difficult to fix, but it's still reality - and 
> that's the purpose of this particular debug helper: to rub reality 
> under our noses, whether we like it or not.
 >
> ( _My_ personal pain threshold for waiting for the computer is 
>   around 1 _second_. If any command does something that i cannot
>   Ctrl-C or Ctrl-Z my way out of i get annoyed. So the historic 
>   limit for the hung tasks check was 10 seconds, then 60 seconds. 
>   But people argued that it's too low so it was raised to 120 then 
>   480 seconds. If almost 10 minutes of uninterruptible wait is still 
>   acceptable then the watchdog can be turned off (because it's 
>   basically pointless to run it in that case - no amount of delay 
>   will be 'bad'). )

Thats about the same definitions for me. But I can accept that if I 
happen to be doing something really crazy.. but this is merely about 
reading some files in and generating indexes out of them. None of the 
file are "huge".. < 15GB for the top 3, average < 100MB.

-- 
Jesper
