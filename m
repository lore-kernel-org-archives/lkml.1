Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab0CND5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 22:57:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58847 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0CND5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 22:57:22 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in commit a2db6842873c8e5a70652f278d469128cb52db70
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
	<alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
	<alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
	<alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Mar 2010 19:57:10 -0800
In-Reply-To: <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org> (Linus Torvalds's message of "Sat\, 13 Mar 2010 14\:57\:20 -0800 \(PST\)")
Message-ID: <m1fx43zhbd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org, gregkh@suse.de, xiyou.wangcong@gmail.com, Larry.Finger@lwfinger.net, jkosina@suse.cz
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, 13 Mar 2010, Jiri Kosina wrote:
>> 
>> Well, the special initialization shouldn't be needed for all the 68 cases 
>> as far as I can see. It's needed only for dynamically allocated sysfs 
>> attributes, the static ones are fine.
>
> So does anybody have a 'grep' for it?
>
> Because we sure as hell don't want to find them one by one, especially 
> since this thing only shows up in a fairly rare configuration (most people 
> do _not_ enable lockdep).

It also only affects those fairly rare lockdep users as well, and the only
affect is to throw a nasty warning message.  Isn't lockdep all about throwing
nasty warning messages?

> So that commit really _is_ broken. I'm seriously going to just revert it 
> if the plan of action is nothing better than "wait for people to report 
> yet another missed conversion". This is _not_ how we convert users.

Linus I think this can be the start of a new development tradition.
The annual birthday scolding from Linus.  I am certain we will all
appreciate the attention.

Unfortunately I have been extremely busy this last week and haven't
been able to do anything so you have only seen my backup plan in
effect where reasonable kernel developers notice the instances I
missed and on a case by case basis trivially fix it.  I believe Greg
has been queuing up many of those case by case fixes.  A few have been
flowing through other maintainers.

Wolfram Sang was figuring out if he could get coccinelle (whatever
that is) to find more of them.

It is my intention to go through all of the reports make certain everything
is getting fixed, and also to look through and see if I can find any more
cases that I have overlooked.

Eric
