Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbYEGXGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbYEGXGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765803AbYEGXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:05:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39834 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbYEGXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:05:40 -0400
Date: Thu, 8 May 2008 01:06:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507230628.GM18516@elf.ucw.cz>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de> <20080507221435.GH18516@elf.ucw.cz> <86802c440805071523u2d858727l2fc6d9edbd30cad8@mail.gmail.com> <20080507223918.GK18516@elf.ucw.cz> <86802c440805071545v75c808a5qcc4a3388c8a0de4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805071545v75c808a5qcc4a3388c8a0de4d@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-07 15:45:18, Yinghai Lu wrote:
> On Wed, May 7, 2008 at 3:39 PM, Pavel Machek <pavel@suse.cz> wrote:
> > On Wed 2008-05-07 15:23:46, Yinghai Lu wrote:
> >  > >  2) HPA said it was bad idea
> >  >
> >  > hpa said white list is not a good idea.
> >
> >  And guess what your patch is doing?
> >
> >
> >  +       switch (c->x86_vendor) {
> >  +       case X86_VENDOR_AMD:
> >  +               if (c->x86 >= 0xf && c->x86 <= 0x11)
> >  +                       set_cpu_cap(c, X86_FEATURE_PAT);
> >  +               break;
> >  +       case X86_VENDOR_INTEL:
> >  +               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >=
> >  15))
> >  +                       set_cpu_cap(c, X86_FEATURE_PAT);
> >  +               break;
> >  +       }
> >
> >  Seems like a whitelist to me. Will break with future CPUs.
> 
> again, i only increased the whitelist a little bit to support AMD
> opteron Rev E, Rev F and Fam10h that I could access.

(Which is what your commit log should have said, btw).

> the code handle future cpus should reach the kernel list before SW
> developer could get system....

There's no reason why 2.6.26 should not work reasonably on cpus
released in 2015.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
