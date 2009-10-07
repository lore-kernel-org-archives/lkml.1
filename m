Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZJGLEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZJGLEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZJGLE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:04:29 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:52735 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbZJGLE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910071237040.9428@localhost.localdomain>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
	 <1254901778.30157.62.camel@eenurkka-desktop>
	 <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com>
	 <1254903263.30157.69.camel@eenurkka-desktop>
	 <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>
	 <1254905013.30157.75.camel@eenurkka-desktop>
	 <f488382f0910070152y1c09602by444fd9466912bbb5@mail.gmail.com>
	 <1254907901.30157.93.camel@eenurkka-desktop>
	 <alpine.LFD.2.00.0910071237040.9428@localhost.localdomain>
Date: Wed, 7 Oct 2009 04:03:16 -0700
Message-ID: <f488382f0910070403s4659869tf3729778ec0082a1@mail.gmail.com>
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Steven Noonan <steven@uplinklabs.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 3:42 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 7 Oct 2009, Eero Nurkkala wrote:
>> For some reason, this path is taken:
>> if (ts->nohz_mode == NOHZ_MODE_INACTIVE)
>>         goto end;
>
> Well, probably because the machine never switched to NOHZ :)
>
>> > Also, this fix should probably be passed on to Greg K. H. (so it goes
>> > in 2.6.31-stable) as well as Ingo Molnar (so it goes into -tip, and
>> > hopefully to Linus for 2.6.32). Both CC'd.
>
> Don't worry, it'll go the right way. No need to cc the world and some
> more :)
>

Sorry if it's not kosher. I was told that when dealing with a
bisection you should CC:
1. those involved with a bisected patch (the Signed-off-by people),
2. those responsible for the affected subsystem (doing an author check
via script[1]),
3. and those to whom a fix should be passed on to.

Any tips so I don't bug the wrong people (or too many people) in the future?

[1] http://www.uplinklabs.net/~tycho/linux/scripts/git-authors-email.sh
(credits to Ingo for making this one. It's handy)

>>
>> From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
>> Date: Wed, 7 Oct 2009 11:54:26 +0300
>> Subject: [PATCH] NOHZ: update idle state properly
>>
>> Commit f2e21c9610991e95621a81407cdbab881226419b
>> had unfortunate side effects with cpufreq governors on
>> some systems.
>>
>> If NOHZ_MODE_INACTIVE was set, ts->inidle was not being
>> set. Then, all subsequent calls from irq_exit() bypassed
>> calls to tick_nohz_start_idle() which resulted in wrong
>> information passed to cpufreq governors. Fix this by
>> updating the state of ts->inidle where it fits the best.
>
> Hmm, nasty that code silently relies on NOHZ functionality even when
> NOHZ is not active. That needs a big fat comment at least.
>
> Nice detective work though !
>
> Thanks,
>
>        tglx
>
