Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYEHXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYEHXNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYEHXMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:12:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64257 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752954AbYEHXMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:12:44 -0400
Date: Fri, 9 May 2008 00:10:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080508105905.3209c659@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507085953.2c08b854@hyperion.delvare> <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
 <20080508105905.3209c659@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> If you had to add a missing semicolon to a source file to get it to
> build again, it would be an "essential" change (without it nothing
> works) but still, you can't claim you added any intellectual value to

 Agreed about this example because the change is mechanical and can almost
be done by an automaton.

> the source file. So, no copyright. The copyright is about how much
> value you add, not how important the change is in the big picture.

 As I wrote, no big concern about it from my side and it looks I will be 
changing more of the file anyway. ;-)

> I'm not going to tell how bad I think the GNU coding standards are, the
> point here is that we don't follow them at all, so whatever they say is
> totally irrelevant. Read Documentation/CodingStyle, it describes what

 Oh come on -- that's just common sense.  If something is good, there is
no point in discarding it without thinking, just because it is a part of a
bigger entity that we consider bad.  I consider it good not because it is
a part of the GNU standard, but because I have concluded that it is and it
is pure coincidence ;-) I have taken it from the said standard.  But as I
said, this is a minor nit here and I can resist from adding extraneous
spaces in pieces of code you are interested in as long as I am able to
track which ones they actually are.

> we do. Also make sure that you run your patches through
> scripts/checkpatch.pl. The rest is up to you, but in general, when
> modifying existing code, you want to stick to what the surrounding code
> looks like.

 I had no problems with writing code checkpatch.pl would swallow without a
blink even before it existed.  It does not mean I should follow the
surrounding mess if this is what the state of code is.

> I do insist ;) Admittedly, double spaces at end of comments are used in
> some places in the kernel tree (I had never seen that before), but they
> are still outnumbered by single-space ending comments, 50 to 1. Do
> what you want in the drivers your create or maintain, but please don't
> change existing comments, especially not in the middle of functional
> changes.

 Fine with me, no problem.

> That's not a matter of being scared, and I was also _not_ asking you to
> split the patch. That's a matter of synchronizing merges between me and
> the architecture maintainer. If I take a patch in my i2c tree which
> touches architecture-specific files, and I only push it to Linus in 2
> months, then chances are that the architecture-specific files in
> question will change several times meanwhile, resulting in conflicts in
> -next and -mm. I am only trying to prevent this from happening. I
> simply think that it is easier to synchronize patches if all
> architecture-specific patches go through the relevant architecture tree.

 Your concern is valid and this is why I proposed the split.  My point
being, unlike the rest of the MIPS arch tree these days the Broadcom bits
are only touched from time to time by two or three people (myself
included), so it is much easier to coordinate changes if they are limited 
to this subarch.  Which means stripping out changes needed elsewhere from 
the i2c patch itself can only improve things.

> BTW, SWARM seems to be only one of the 4 SiByte platforms we support.

 I think nobody really knows for sure how many Broadcom/SiByte platforms 
we support at the moment. ;-)  I am fairly sure there is some interest in 
the BigSur, SWARM and Sentosa only.

> What about the other ones? Your changes to the i2c-sibyte driver could
> cause the i2c bus registration to fail, as the other platforms do not
> declare I2C devices, the bus numbers 0 and 1 won't be reserved by
> i2c-core. Care to comment on this?

 Well, arch/mips/sibyte/swarm/ is included for all the three above as well 
as a couple of other I may not necessarily be sure what they are even.  So 
this should be of no concern.

 BTW, do you mean i2c_add_numbered_adapter() will fail if no devices have
been declared to exist on the given bus with i2c_register_board_info()?  
That sounds strange...  Note in all cases there are EEPROMs (onboard ones
as well as optionally SPD ones) on both buses on Broadcom/SiByte boards
and they are handled by a legacy client driver.  The Broadcom SOC is
actually capable to bootstrap from one of these EEPROMs (rather than form
the usual system parallel Flash ROM).

  Maciej
