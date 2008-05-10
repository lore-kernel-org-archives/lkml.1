Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYEJGyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYEJGyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 02:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYEJGyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 02:54:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39279 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYEJGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 02:54:11 -0400
Date: Sat, 10 May 2008 08:53:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [i2c] [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Message-ID: <20080510085340.29c26aef@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805100301100.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
	<Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
	<200805071625.20430.david-b@pacbell.net>
	<Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
	<20080509100841.151eabcd@hyperion.delvare>
	<Pine.LNX.4.55.0805092127410.10552@cliff.in.clinika.pl>
	<20080509232146.18638986@hyperion.delvare>
	<Pine.LNX.4.55.0805100301100.10552@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 03:21:35 +0100 (BST), Maciej W. Rozycki wrote:
> > This was an option when the functions where introduced 9 years ago.
> > But now that it was done, renaming them would cause even more
> > confusion, I think. I would be fine with adding comments in i2c-core.c
> > or improving Documentation/i2c/smbus-protocol to make it more obious,
> > though.
> > 
> > On a related note, you will notice that the other i2c_smbus_* functions
> > do not follow the naming of SMBus transactions. Again that's something
> > I regret but I feel that changing the names now would cause a lot of
> > confusion amongst developers, so I'm not doing it.
> 
>  It may not be worth the effort, but if done in bulk for all the users in
> the tree, there should be no problem with that.  I am fairly sure there
> were changes of this kind from time to time, with occasional screams heard
> in response from some dark corners, but no big pain.  We obviously
> explicitly disregard out-of-tree users and for occasional contributors
> asking: "Where the * has this function gone?" there is the Documentation/
> tree to provide a greppable reference, so generally not a big deal.

It's not that easy. There are some drivers which are both in-tree and
out-of-tree, for which such a change means adding ifdefs. And there is
i2c-dev.h (the user-space one) which has similar functions, if we
rename only the kernel variants, there will be some confusion. But if
we rename also the user-space variants, then it's up to 2.4 kernel
users to have different names for kernel-space and user-space functions.

All in all I'd say it is not worth the effort. There are many other
tasks where our time will be better used.

> > Just one patch should be enough, if I agree with all the changes. You
> > might make a separate patch with the things I may not agree with, so
> > that you don't have to cherry-revert them if I indeed don't agree, and
> > we just merge them if I do agree.
> 
>  Hmm, technically you do not seem to be responsible to accept changes
> under drivers/rtc/, so I will split them anyway for others to decide.

Huu, sorry, for some reason I thought that we were still speaking about
i2c-sibyte. Of course I don't have my say about what happens in
drivers/rtc.

-- 
Jean Delvare
