Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbXJ0UHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbXJ0UHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXJ0UHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:07:39 -0400
Received: from smtp3.netcabo.pt ([212.113.174.30]:17840 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbXJ0UHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:07:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAEI3I0dViqaH/2dsb2JhbAAMkDw
Message-ID: <47239A37.8000401@rncbc.org>
Date: Sat, 27 Oct 2007 21:06:15 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23-rt4 (was 2.6.23-rt1 trouble)
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org> <47234EA1.4050006@rncbc.org> <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2007 20:07:35.0852 (UTC) FILETIME=[0440DEC0:01C818D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> --
> 
> On Sat, 27 Oct 2007, Rui Nuno Capela wrote:
> 
>>> On Mon, October 15, 2007 11:49, Rui Nuno Capela wrote:
>>>> I am experiencing some highly annoying but intermitent freezing on a
>>>> pentium4 2.80G HT/SMT box, when doing normal desktop work with 2.6.23-rt1.
>>>>
>>>>
>>>> The same crippling behavior does not occur on a Core 2 Due T7200 2.0G
>>>> SMP, so I suspect it's something due specific to the SMT scheduling
>>>> support (Hyper-Threading). But can't tell for sure, obviously :)
>>>>
>>> I was wrong. After several trials the same behavior also occurs on the
>>> Core2 Duo T7200. It just took longer to show its nasty.
>>>
>>>
>>>> The symptoms are noticeable primarily as some X/GUI intermitent freezing,
>>>> sometimes only one application, then several and ultimately the whole X
>>>> desktop becomes completely unresponsive. It looks like scheduling
> 
> When things start to freeze, could you capture the output of a sysrq-t.
> 

yes, you can find a complete serial console capture here, where it holds
the final SysRq-T output:
  http://www.rncbc.org/datahub/console-2.6.23.1-rt4.1-1.log

the corresponding .config is also there:
  http://www.rncbc.org/datahub/config-2.6.23.1-rt4.1

the reason this is a new kernel build, following a shot in the dark from
nick mainsbridge, which let out the ntfs module build (CONFIG_NTFS_FS is
not set) suggesting that would mitigate similar freezes.

in deed the general feel is that it seems to run longer and less prone
to those incidents, but that is just a gut feeling, nothing more.

hope this be any useful.

> 
>>>> problems. There is this hint that switching to a spare console terminal
>>>> (via Ctrl+Alt+Fn) might cause later recovery. But its just a question of
>>>> some more time for it just happens again and again, one after another,
>>>> several applications becoming temporarily frozen and just by luck the
>>>> system gets back to normal, probably due to some incidental shake-up :)
>>>> but there are other times that nothing seems to help with no alternative
>>>> to the power-reset switch.
>>>>
>>>> I could not find any evidence on dmesg or in the system logs, of any
>>>> apparent trouble. No BUGs, no oops, no panics, no nothing. It just
>>>> freezes, this and that, now and then. It just makes it all unworkable
>>>> and obviously subject to ditching.
>>>>
>>>> Again, this only happens on this P4/HT box. On a Core2 Duo laptop, with
>>>> same 2.6.23-rt1 with the very same kernel configuration, it does not show
>>>> any illness and is running quite fine.
>>>>
>>> False. It used to run fine, until the creeps happen first time :(
>>>
>>>
>>>> Remember one report I had about a similar freezing behavior? Now it's
>>>> happening the other way around: the core2 is OK, the pentium4 is KO.
>>>>
>>> Now it applies to all 2.6.23-rt1 images I could test upon.
>>>
>>>
>>>> One naive suspicion goes like the new rcu-preempt code is to blame, since
>>>> I don't remember having this or any other trouble with 2.6.23-rc8-rt1.
>>>>
>>> Not be sure anymore, but this seems to be still a valid assumption.
>>>
>> just to let you know that still the same trouble persists with 2.6.23.1-rt4
>>
>> .config can be found here:
>>    http://www.rncbc.org/datahub/config-2.6.23.1-rt4.0
>>
> 
> I have a P4HT laptop (unfortunately with no serial). I use it as one of my
> main machines, so it will suck for me when it freezes ;-). I'll take your
> config and try it out.
> 
> I'll most likely do this on Monday since process Wife has the highest
> priority over the weekend ;-)
> 

that is also true here :)

otoh, as reported before, the freezes are not exclusive to P4HT, which
is the main box I'm been reporting here (the one which has a good old
serial port anyway), but also applies to my other laptop, an core2 duo
t7200.

bye
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
