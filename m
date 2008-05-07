Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbYEGV2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbYEGV2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbYEGV1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:27:52 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64271 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755906AbYEGV1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:27:50 -0400
Date: Wed, 7 May 2008 22:25:08 +0100 (BST)
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
In-Reply-To: <20080507094343.25f279b9@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805072214090.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507090514.3a86cf4b@hyperion.delvare> <Pine.LNX.4.64.0805070936060.6341@anakin>
 <20080507094343.25f279b9@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> > > i2c-foo.c is consistently used for i2c bus driver themselves so far.
> > > It's somewhat confusing to see you name platform code that way. It's
> > > also redundant, given that the file lives in the swarm platform
> > > directory. May I suggest naming this file just
> > > arch/mips/sibyte/swarm/i2c.c? Other architectures (cris, arm) are doing
> > > this already.
> > 
> > Is there any chance CONFIG_I2C_BOARDINFO could become tristate?
> > If yes, it's problematic if you have multiple modules called i2c.ko.
> 
> No, CONFIG_I2C_BOARDINFO is boolean by nature, it will never become
> tristate.

 I can do that and I have considered it while preparing the change.  What
convinced me not to use a name that is already present elsewhere in the
tree is the confusion that it sometimes causes.  For example during a
debugging session GDB only reports the file name and not the leading
pathname (and some people do run GDB over the kernel).  Of course the
actual file can still be chased with some `find' and `grep' scriptery, but
why to create a problem in the first place?

 I consider repeated file names throughout a tree of a single program a 
namespace pollution similar to one with repeated static symbol names.  
While syntactically valid and working, it asks for unnecessary confusion.

 This is my point of view, but I can see others may not necessarily follow
it.  I am fine with changing the name to i2c.c as it is unlikely I will
run GDB over it. ;-)

  Maciej
