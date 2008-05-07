Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYEGVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYEGVQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbYEGVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:15:50 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64125 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763689AbYEGVPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:15:46 -0400
Date: Wed, 7 May 2008 22:13:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080507085953.2c08b854@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507085953.2c08b854@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Minor corrections which would ideally belong to a separate patch
> (there's a whole lot more cleanups that could be done in that driver,
> BTW...)

 Not suprising, as usually with most pieces of code for the SWARM and the 
SiByte SOC.  That can be done gradually, but mixing a driver overhaul with 
functional changes usually only results in confusion later on.

> I don't think that the minor changes below are enough for you to claim
> copyright on that driver.

 Well, I decide whether or not to add one based on how important changes
are from the piece's of code point of view.  In this case the change is
essential for new-style client drivers to work at all, which I think is
more important than e.g. a lot of cosmetical changes throughout would be.  
But I do not insist on keeping it -- if you think I misjudged on this
occasion, I see no problem with discarding it.

> Why do you double the space and the end of comments? Never seen that
> before, and I can't see the idea.

 This is mostly habitual -- this is what the GNU Coding Standard specifies
for comments and which is enforced for GNU software which I have dealt a
lot with.  I think the idea is it improves readability and I tend to
agree.  The same goes for using a capital at the beginning and a full stop
at the end of sentences in comments -- it improves readability and
(together with a good style of code itself) makes the result look more
professional.  Certainly well-formatted code is easier to comprehend for 
someone looking at it for the first time.

 I do not insist on the extraneous space if you have a strong opinion 
against though.

> I'm not sure how you intend to push these changes upstream. I would
> take a patch only touching drivers/i2c/busses/i2c-sibyte.c in my i2c
> tree, however a patch also touching arch code, must be handled be the
> maintainer for that architecture or platform.

 Andrew has spoken (thank you, Andrew) and I would only like to add an
explanation why I have not split this change further.  Certainly it is
functionally consistent.  Then adding i2c-swarm.c only breaks things as
the onchip buses suddenly get the numbers 2 and 3.  On the other hand, if
adding the i2c-sibyte.c change only, it will take a while until it
propagates back to the MIPS tree and without that as it is there is no
single way to use the whole set of changes as the clock device will not be
seen.

 If you are scared off by the MIPS-specific Makefile (lib vs obj) changes,
then I think they should be reasonably easy to sort out separately in a
couple of days as functionally not changing anything.  The only other file
in the affected subdirectory that depends on a config option uses
CONFIG_KGDB which does not seem to rely on being pulled implicitly by the
linker.  But such a mechanical change by itself would make little sense 
(don't fix what isn't broken), so I have not pushed it without a 
reasonable justification.

 Ralf -- what do you think about the Makefile changes?  I can send you a 
separate patch which will reduce the span of this one.

  Maciej
