Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYEHI7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYEHI7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYEHI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:59:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45396 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYEHI7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:59:37 -0400
Date: Thu, 8 May 2008 10:59:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <20080508105905.3209c659@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
	<20080507085953.2c08b854@hyperion.delvare>
	<Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 7 May 2008 22:13:23 +0100 (BST), Maciej W. Rozycki wrote:
> Hi Jean,
> 
> > Minor corrections which would ideally belong to a separate patch
> > (there's a whole lot more cleanups that could be done in that driver,
> > BTW...)
> 
>  Not suprising, as usually with most pieces of code for the SWARM and the 
> SiByte SOC.  That can be done gradually, but mixing a driver overhaul with 
> functional changes usually only results in confusion later on.

I fully agree.

> > I don't think that the minor changes below are enough for you to claim
> > copyright on that driver.
> 
>  Well, I decide whether or not to add one based on how important changes
> are from the piece's of code point of view.  In this case the change is
> essential for new-style client drivers to work at all, which I think is
> more important than e.g. a lot of cosmetical changes throughout would be.  
> But I do not insist on keeping it -- if you think I misjudged on this
> occasion, I see no problem with discarding it.

If you had to add a missing semicolon to a source file to get it to
build again, it would be an "essential" change (without it nothing
works) but still, you can't claim you added any intellectual value to
the source file. So, no copyright. The copyright is about how much
value you add, not how important the change is in the big picture.

> > Why do you double the space and the end of comments? Never seen that
> > before, and I can't see the idea.
> 
>  This is mostly habitual -- this is what the GNU Coding Standard specifies
> for comments and which is enforced for GNU software which I have dealt a
> lot with.

>From Documentation/CodingStyle:

"First off, I'd suggest printing out a copy of the GNU coding standards,
and NOT read it.  Burn them, it's a great symbolic gesture."

I'm not going to tell how bad I think the GNU coding standards are, the
point here is that we don't follow them at all, so whatever they say is
totally irrelevant. Read Documentation/CodingStyle, it describes what
we do. Also make sure that you run your patches through
scripts/checkpatch.pl. The rest is up to you, but in general, when
modifying existing code, you want to stick to what the surrounding code
looks like.

>  I think the idea is it improves readability and I tend to
> agree.  The same goes for using a capital at the beginning and a full stop
> at the end of sentences in comments -- it improves readability and
> (together with a good style of code itself) makes the result look more
> professional.  Certainly well-formatted code is easier to comprehend for 
> someone looking at it for the first time.
> 
>  I do not insist on the extraneous space if you have a strong opinion 
> against though.

I do insist ;) Admittedly, double spaces at end of comments are used in
some places in the kernel tree (I had never seen that before), but they
are still outnumbered by single-space ending comments, 50 to 1. Do
what you want in the drivers your create or maintain, but please don't
change existing comments, especially not in the middle of functional
changes.

> > I'm not sure how you intend to push these changes upstream. I would
> > take a patch only touching drivers/i2c/busses/i2c-sibyte.c in my i2c
> > tree, however a patch also touching arch code, must be handled be the
> > maintainer for that architecture or platform.
> 
>  Andrew has spoken (thank you, Andrew) and I would only like to add an
> explanation why I have not split this change further.  Certainly it is
> functionally consistent.  Then adding i2c-swarm.c only breaks things as
> the onchip buses suddenly get the numbers 2 and 3.  On the other hand, if
> adding the i2c-sibyte.c change only, it will take a while until it
> propagates back to the MIPS tree and without that as it is there is no
> single way to use the whole set of changes as the clock device will not be
> seen.
> 
>  If you are scared off by the MIPS-specific Makefile (lib vs obj) changes,
> then I think they should be reasonably easy to sort out separately in a
> couple of days as functionally not changing anything.  The only other file
> in the affected subdirectory that depends on a config option uses
> CONFIG_KGDB which does not seem to rely on being pulled implicitly by the
> linker.  But such a mechanical change by itself would make little sense 
> (don't fix what isn't broken), so I have not pushed it without a 
> reasonable justification.
> 
>  Ralf -- what do you think about the Makefile changes?  I can send you a 
> separate patch which will reduce the span of this one.

That's not a matter of being scared, and I was also _not_ asking you to
split the patch. That's a matter of synchronizing merges between me and
the architecture maintainer. If I take a patch in my i2c tree which
touches architecture-specific files, and I only push it to Linus in 2
months, then chances are that the architecture-specific files in
question will change several times meanwhile, resulting in conflicts in
-next and -mm. I am only trying to prevent this from happening. I
simply think that it is easier to synchronize patches if all
architecture-specific patches go through the relevant architecture tree.

BTW, SWARM seems to be only one of the 4 SiByte platforms we support.
What about the other ones? Your changes to the i2c-sibyte driver could
cause the i2c bus registration to fail, as the other platforms do not
declare I2C devices, the bus numbers 0 and 1 won't be reserved by
i2c-core. Care to comment on this?

Thanks,
-- 
Jean Delvare
