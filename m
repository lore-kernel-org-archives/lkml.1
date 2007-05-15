Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbXEOTPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbXEOTPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXEOTPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:15:10 -0400
Received: from lazybastard.de ([212.112.238.170]:50369 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbXEOTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:15:08 -0400
Date: Tue, 15 May 2007 21:10:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070515191046.GA1220@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515183725.GA22003@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070515183725.GA22003@uranus.ravnborg.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:37:25 +0200, Sam Ravnborg wrote:
> On Tue, May 15, 2007 at 05:19:20PM +0200, Jörn Engel wrote:
> > [ I have put everyone that gave comments to the last patch on Cc:.  Hope
> > that doesn't offend anyone. ]
> > 
> > 
> > Add LogFS, a scalable flash filesystem.
> 
> Have you run sparse on this code?

Several thousand times. :)

> I do not recall if you have written something about it.
> I do not see any obvious things sparse would catch (just browsing quickly)
> but it's always a good thing to do.

Absolutely! I added this line for sparse:
+#define __CHECK_ENDIAN__ 

Not sure how much of the kernel is endian-clean.  Logfs should be.

> +++ linux-2.6.21logfs/fs/logfs/progs/fsck.c     2007-05-15 00:54:22.000000000 +0200
> @@ -0,0 +1,332 @@
> +/*
> + * fs/logfs/prog/fsck.c        - filesystem check
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + *
> + * In principle this could get moved to userspace.  However it might still
> + * make some sense to keep it in the kernel.  It is a pure checker and will
> + * only report problems, not attempt to repair them.
> + */
> +#include "../logfs.h"
> +
> If potential userspace tools needs to include ../logfs.h then there is
> something that ought to be moved to include/linux/logfs.h instead.

There shouldn't be anything left in ../logfs.h that is needed for
userspace.  But the kernel fsck is lame and calls into functions like
iget(), which it pulls in from ../logfs.h.

Jörn

-- 
The only real mistake is the one from which we learn nothing.
-- John Powell
