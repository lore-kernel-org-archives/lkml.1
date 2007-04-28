Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXD1HHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXD1HHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161427AbXD1HHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:07:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41728 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161359AbXD1HHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:07:39 -0400
Date: Sat, 28 Apr 2007 09:07:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Message-ID: <20070428070716.GH2994@elf.ucw.cz>
References: <200704271737.31192.rjw@sisk.pl> <200704280009.19639.rjw@sisk.pl> <20070427220710.GC2994@elf.ucw.cz> <200704280056.53831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704280056.53831.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > +#ifdef CONFIG_FREEZER
> > > > > > +	/* Used by the process freezer, defined in freezer.h */
> > > > > > +	unsigned int freezer_flags;
> > > > > 
> > > > > unsigned long freezer_flags; ??
> > > > 
> > > > I guess so.
> > > 
> > > Still, on x86_64, for example, we'll waste 4 bytes by using 'unsigned long'
> > > here, which I wouldn't like to do.
> > > 
> > > Is it acceptable to use explicit type casting in set_bit() and friends?
> > 
> > I'm afraid set_bit & friends are only defined on unsigned long.
> 
> On x86_64 they are defined on anything, even on huge bitmaps.
> 
> > You can cast, but you may run into some nasty surprise... like damaging
> > surrounding bytes on 64-bit architectures != x86_64.
> 
> Let's use unsigned long, then, but I'm not really happy with that.

Ask the architecture people, but comments like

/data/l/linux/include/linux/agpgart.h:  long access_flags;      /* long req'd for set_bit --RR */

Make me think long is needed.

 * bitmaps provide bit arrays that consume one or more unsigned
 * longs.  The bitmap interface and available operations are listed
 * here, in bitmap.h

...I'm afraid we need ulongs.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
