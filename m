Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbYEITjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbYEITjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYEITj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:39:26 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61445 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764708AbYEITjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:39:24 -0400
Date: Fri, 9 May 2008 20:36:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080508095658.40eb74f4@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805092019100.10552@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507090514.3a86cf4b@hyperion.delvare> <Pine.LNX.4.64.0805070936060.6341@anakin>
 <20080507094343.25f279b9@hyperion.delvare> <Pine.LNX.4.55.0805072214090.25644@cliff.in.clinika.pl>
 <20080508095658.40eb74f4@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> $ find linux-2.6.26-rc1 -name Kconfig | wc -l
> 455
> $ find linux-2.6.26-rc1 -name Makefile | wc -l
> 1030
> $

 Well, these are not pieces of code and serve a different purpose, don't
they?

> Not to mention the 102 setup.c, 87 irq.c, 62 time.c... It is very
> common to have duplicated file names in the kernel tree because it
> supports so many architectures and platforms. In general, when you work

 Well, that is not a technical argument.  It is a fact of life, sure, but
it does not necessarily mean it is right, but perhaps that nobody has
really thought about it.

> on a given architecture or platform, names become unique again. Taking
> GDB as an example again, you definitely know what architecture you are
> debugging, so there should be relatively little ambiguity on what files
> are involved.

 Hmm, why to have little ambiguity, when you can have none?  We do not
rely on crippled filesystems, so we do not have to save characters in file
names -- we keep them reasonably short anyway.  I say there is no
technical advantage in having duplicate file names throughout the tree
(please name one if I am wrong) and there are advantages -- however small,
but still -- in keeping file names unique.  Therefore the gain from
converting the existing file names may not justify the effort required,
but it does not mean new additions may not take the gain into account?

> (On top of that, I'd argue that we _should_ be able to display relative
> paths to file names when debugging.)

 Human's perception is limited -- GDB's `info frame' is probably already
overloaded with information, so adding the path to the source file in
question will not make it any better.

> Your point about the "single program namespace" is certainly valid for
> small to medium-size programs, but in the case of something as big as
> the kernel, it probably no longer holds.

 I think it is actually the reverse -- the bigger a project is, the easier
to get lost within. ;-)  With small programs it is easier to maintain,
while with bigger ones it is really where it pays off.

> I don't have a strong opinion on this either, it is very unlikely that
> I'll ever have to deal with this file personally. I'm only telling you
> what the common practice is in the kernel tree.

 I don't think this practice has been architected and see above for
justification why it may not necessarily be the cleverest idea. :-)

  Maciej
