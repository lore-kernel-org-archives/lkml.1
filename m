Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYDRJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYDRJfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYDRJfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:35:23 -0400
Received: from www.tglx.de ([62.245.132.106]:54384 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbYDRJfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:35:22 -0400
Date: Fri, 18 Apr 2008 11:35:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Dubov <oakad@yahoo.com>
cc: linux-kernel@vger.kernel.org, joern@logfs.org, ben@fluff.org
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <143829.94600.qm@web36707.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0804181126350.3261@apollo.tec.linutronix.de>
References: <143829.94600.qm@web36707.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Alex Dubov wrote:
>
> First, with all the respect to Jorn, alauda driver can only be
> considered "proof of concept". It does not try to abstract any
> smartmedia functionality.
> 
> Second, ssfdc is hopelessly obsolete and requires rewrite.

Nobody claimed that it is perfect.

> Third, there's no attempt made by mtd to support advanced
> functionality present in many smartmedia and all memorystick
> readers: adapter side copy and multi page programming (this mostly
> relates to memorystick, of course). I also failed to see any support
> for device writing policy, needed to discern, for example,
> sequential page programmable devices vs. block programmable
> devices. I also failed to see an unified approach to page-accessible
> devices, meaning duplication of "bouncing" code in the backends.

And instead of addressing the missing features and shortcomings you
add a new duplicated code layer which is only useful for a restricted
set of hardware.

> Considering all this, amount of effort needed for satisfactory
> support of smartmedia through mtd was found by me to be far greater
> than coming with stand-alone implementation.

Yeah and you made this decision on your own w/o even discussing the
issues at hand with the mtd developers before implementing a separate
code stack. And now we should be impressed and merge it. That's not
the way it works.

> I do agree, that eventually my work can be merged into mtd. I don't
> see what prevents merging of my implementation as is on an interim
> basis, considering there are no real alternatives.

Merging your code as is is a bad idea as it contains userspace visible
changes which can not be undone easily. Interim solutions burden more
problems on us than they solve.

Thanks,
	tglx
