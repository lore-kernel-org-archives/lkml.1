Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYANWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYANWjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYANWjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:39:35 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:48844 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYANWje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:39:34 -0500
Message-ID: <478BE49B.3000702@gmail.com>
Date: Mon, 14 Jan 2008 14:39:23 -0800
From: John Hubbard <john.hubbard@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Tuomo Valkonen <tuomov@iki.fi>
CC: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
In-Reply-To: <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a340b2e653f5c7e365dae0426e8fce169ef193a6bfc3dd485749966fca5007de81975a53b1949f7008a8bb3e8e732a70350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.141.247.138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuomo Valkonen wrote:
> On 2008-01-13 18:11 -0500, Theodore Tso wrote:
>> It's much more likely that this early in your boot cycle, your clock is
>> sometimes incorrect.
> 
> I doubt it. I get this nearly _always_ when the system crashes, which
> accounts for the vast majority of the times I boot it. (I wish swsusp
> didn't suck so much..)
> 
>> Is the "9192" number roughly constant, or is it always changing?
> 
> No. That's the number I got last time, but typically I've got 
> something in the 3xxxx range. 
> 
>> If your machine is on the network, then the "ntpdate"
>> program could be setting your time so that it looks correct, but
>> that's after e2fsck is run.  
> 
> ntpdate isn't run by any of the init scripts. ntpd is, but like I 
> already mentioned, I doubt it would correct vastly incorrect time,
> not even being able to track and correct when it advances fast.
> 

ntpd will allow an initial correction that is arbitrarily large, if run 
with the -g option. This is a commonly used option. I see it is running 
on my stock Fedora Core 8, for example. So there is often no need to run 
ntpdate.

Also, ntpd keeps track of how fast your local clock tends to drift, and 
attempts to compensate. So, even if the local clock runs quite fast or 
slow, you'll normally get good results. The exception would be if you 
clock's drift rate jumps around; for example: fast today, slow tomorrow.

On most systems, ntpd will also copy the current time back to the CMOS, 
periodically, and during an orderly shutdown.

Hope that adds some clarity.

thanks,
John Hubbard
