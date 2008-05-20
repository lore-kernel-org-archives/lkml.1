Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbYETIdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbYETIdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbYETIcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:32:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128AbYETIcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:32:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Date: Tue, 20 May 2008 10:30:11 +0200
User-Agent: KMail/1.9.9
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
References: <13762.1211142411@vena.lwn.net> <200805200114.24819.arnd@arndb.de> <20080520062056.GA5292@infradead.org>
In-Reply-To: <20080520062056.GA5292@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805201030.14092.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/wnQeXvIIp+Jj3ugC+9KoU1KbdQ4TiW5ApijJ
 L6sR9vLa5oborAZNiyd95eGX8vrdc9Wgfnkot+D5GJQC8cd4Xc
 yQIPEfebEempaNAh8mb6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Christoph Hellwig wrote:
> On Tue, May 20, 2008 at 01:14:23AM +0200, Arnd Bergmann wrote:
> > The Big Kernel Lock has been pushed down from chardev_open
> > to misc_open, this change moves it to the individual watchdog
> > driver open functions.
> > 
> > As before, the change was purely mechanical, most drivers
> > should actually not need the BKL.
> 
> Actually I'd prefer to fix this for real.  This single open stuff aswell
> as same set of ioctls are duplicated all over the watchdog drivers.  We'd
> be much better off introducing a simple watchdog layer that handles this
> plus proper locking and convert drivers over to it gradually.

I fully agree, I thought the same thing when I did the patches. I remember
that Wim had a git tree doing this, which is still active at
http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=commitdiff;h=732c54027e6c866f98857c4a6d1c6c466459dcd5

Unfortunately, it hasn't seen much activitity over the last two years, and
the number of watchdog drivers seems to have exploded: I count 67 of them,
including some outside of drivers/watchdog.

Wim, was there anything preventing you from integrating the generic
watchdog layer back then?

	Arnd <><
