Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbYI1I4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbYI1I4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 04:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYI1I4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 04:56:01 -0400
Received: from nebensachen.de ([195.34.83.29]:57553 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYI1I4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 04:56:00 -0400
X-Hashcash: 1:20:080928:tglx@linutronix.de::dkdGzn3xodzUb7O1:00000000000000000000000000000000000000000003QHh
X-Hashcash: 1:20:080928:mingo@elte.hu::ONN2zd2aZPwGhnA0:00007wvL
X-Hashcash: 1:20:080928:linux-kernel@vger.kernel.org::VNgrIKf6IWQtdEGN:000000000000000000000000000000000AqFX
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: udelay and timers
References: <87skrnz6o0.fsf@denkblock.local>
	<alpine.LFD.1.10.0809261141350.27026@apollo.tec.linutronix.de>
Date: Sun, 28 Sep 2008 10:55:22 +0200
Message-ID: <87prmowsxx.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Apologies for the delayed response, I have just temporary internet
access right now.]

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 26 Sep 2008, Elias Oltmanns wrote:
>
>> Hi all,
>> 
>> finally, I have managed to identify the cause of some odd symptoms on my
>> system, but I need your help to understand what is really going on and
>> what should be done to fix things. My problem is this: I have written a
>> small test module which, in due course, does the following:
[...]
>> Now, I can observe that because of the call to udelay() in the callback
>> of timera, timerb rather frequently fires *much* too early, i.e. after
>> less than 1 msec rather than 20 msecs. This means that an udelay in a
>> timer callback heavily affects the precision of other timers running at
>> the time. The effect if particularly grave on a tickless system, but
>> even when NO_HZ was not set, I have observed this behaviour.
>> 
>> As I understand, udelay() is meant to be usable in softirq context. What
>> can I do to find out what exactly causes the problem?
>
> I have no idea what's going wrong. Can you please provide the full
> source of your test module ?

Even though I still don't understand exactly what is going on myself, I
have, after some more testing, come to the conclusion that the ath5k
driver is to blame for messing up softirq handling. I have to talk to
the wireless people in order to get this sorted out. Sorry for the
noise.

Regards,

Elias
