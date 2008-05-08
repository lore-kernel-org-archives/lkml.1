Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYEHH5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYEHH5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYEHH5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:57:37 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42830 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYEHH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:57:36 -0400
Date: Thu, 8 May 2008 09:56:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <20080508095658.40eb74f4@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805072214090.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
	<20080507090514.3a86cf4b@hyperion.delvare>
	<Pine.LNX.4.64.0805070936060.6341@anakin>
	<20080507094343.25f279b9@hyperion.delvare>
	<Pine.LNX.4.55.0805072214090.25644@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 7 May 2008 22:25:08 +0100 (BST), Maciej W. Rozycki wrote:
> > i2c-foo.c is consistently used for i2c bus driver themselves so far.
> > It's somewhat confusing to see you name platform code that way. It's
> > also redundant, given that the file lives in the swarm platform
> > directory. May I suggest naming this file just
> > arch/mips/sibyte/swarm/i2c.c? Other architectures (cris, arm) are doing
> > this already.
>
>  I can do that and I have considered it while preparing the change.  What
> convinced me not to use a name that is already present elsewhere in the
> tree is the confusion that it sometimes causes.  For example during a
> debugging session GDB only reports the file name and not the leading
> pathname (and some people do run GDB over the kernel).  Of course the
> actual file can still be chased with some `find' and `grep' scriptery, but
> why to create a problem in the first place?
>
>  I consider repeated file names throughout a tree of a single program a 
> namespace pollution similar to one with repeated static symbol names.  
> While syntactically valid and working, it asks for unnecessary confusion.

$ find linux-2.6.26-rc1 -name Kconfig | wc -l
455
$ find linux-2.6.26-rc1 -name Makefile | wc -l
1030
$

Not to mention the 102 setup.c, 87 irq.c, 62 time.c... It is very
common to have duplicated file names in the kernel tree because it
supports so many architectures and platforms. In general, when you work
on a given architecture or platform, names become unique again. Taking
GDB as an example again, you definitely know what architecture you are
debugging, so there should be relatively little ambiguity on what files
are involved.

(On top of that, I'd argue that we _should_ be able to display relative
paths to file names when debugging.)

Your point about the "single program namespace" is certainly valid for
small to medium-size programs, but in the case of something as big as
the kernel, it probably no longer holds.

>  This is my point of view, but I can see others may not necessarily follow
> it.  I am fine with changing the name to i2c.c as it is unlikely I will
> run GDB over it. ;-)

I don't have a strong opinion on this either, it is very unlikely that
I'll ever have to deal with this file personally. I'm only telling you
what the common practice is in the kernel tree.

-- 
Jean Delvare
