Return-Path: <linux-kernel-owner+w=401wt.eu-S936467AbXJQRjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936467AbXJQRjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbXJQRjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:39:23 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:51965 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932856AbXJQRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:39:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAABvlFUdRVHC0/2dsb2JhbAAMkCc
Message-ID: <471648B8.1030007@rncbc.org>
Date: Wed, 17 Oct 2007 18:39:04 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23-rt1 trouble
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org>
In-Reply-To: <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Oct 2007 17:39:19.0689 (UTC) FILETIME=[A5989F90:01C810E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, October 15, 2007 11:49, Rui Nuno Capela wrote:
> On Fri, October 12, 2007 03:04, Steven Rostedt wrote:
> 
>> We are pleased to announce the 2.6.23-rt1 tree, which can be
>> downloaded from the location:
>> 
>> http://www.kernel.org/pub/linux/kernel/projects/rt/
>> 
>> Changes since 2.6.23-rc9-rt2
>> 
>> - updated to 2.6.23
>> 
>> - spin_trylock_irqsave macro fix (Sébastien Dugué)
>> 
>> - move rcu_preempt_boost init earlier (Steven Rostedt)
>> 
>> - rt task send IPI condition update (Mike Kravetz)
>> 
> 
> I am experiencing some highly annoying but intermitent freezing on a
> pentium4 2.80G HT/SMT box, when doing normal desktop work with 2.6.23-rt1.
> 
> 
> The same crippling behavior does not occur on a Core 2 Due T7200 2.0G
> SMP, so I suspect it's something due specific to the SMT scheduling
> support (Hyper-Threading). But can't tell for sure, obviously :)
>

I was wrong. After several trials the same behavior also occurs on the
Core2 Duo T7200. It just took longer to show its nasty.


> The symptoms are noticeable primarily as some X/GUI intermitent freezing,
> sometimes only one application, then several and ultimately the whole X 
> desktop becomes completely unresponsive. It looks like scheduling 
> problems. There is this hint that switching to a spare console terminal 
> (via Ctrl+Alt+Fn) might cause later recovery. But its just a question of
> some more time for it just happens again and again, one after another, 
> several applications becoming temporarily frozen and just by luck the 
> system gets back to normal, probably due to some incidental shake-up :) 
> but there are other times that nothing seems to help with no alternative 
> to the power-reset switch.
> 
> I could not find any evidence on dmesg or in the system logs, of any
> apparent trouble. No BUGs, no oops, no panics, no nothing. It just
> freezes, this and that, now and then. It just makes it all unworkable
> and obviously subject to ditching.
> 
> Again, this only happens on this P4/HT box. On a Core2 Duo laptop, with
> same 2.6.23-rt1 with the very same kernel configuration, it does not show 
> any illness and is running quite fine.
> 

False. It used to run fine, until the creeps happen first time :(


> Remember one report I had about a similar freezing behavior? Now it's
> happening the other way around: the core2 is OK, the pentium4 is KO.
> 

Now it applies to all 2.6.23-rt1 images I could test upon.


> One naive suspicion goes like the new rcu-preempt code is to blame, since
>  I don't remember having this or any other trouble with 2.6.23-rc8-rt1.
> 

Not be sure anymore, but this seems to be still a valid assumption.

Just in case someone might try in reproducing this showstopper, the
kernel .config is available from here:

  http://www.rncbc.org/datahub/config-2.6.23-rt1.0

dmesg output as right after init:

  http://www.rncbc.org/datahub/dmesg-2.6.23-rt1.0

which can't really tell where to look :)


Cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
