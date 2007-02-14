Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXBNM3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXBNM3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXBNM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:29:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34909 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932224AbXBNM3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:29:38 -0500
Date: Wed, 14 Feb 2007 13:26:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070214122645.GE22008@elf.ucw.cz>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170880572.11736.4.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-02-08 07:36:12, Rusty Russell wrote:
> On Wed, 2007-02-07 at 12:35 +0000, Pavel Machek wrote:
> > Ugh, it sounds like paravirt is more b0rken then I thought. It should
> > always to the proper delay, then replace those udelays that are not
> > needed on virtualized hardware with something else.
> > 
> > Just magically defining udelay into nop is broken.
> 
> We'd have to audit and figure out what udelays are for hardware and
> which are not, but the evidence is that the vast majority of them are
> for hardware and not needed for virtualization.

You did not time to do the full audit, so you just did #define.

> Changing udelay to "hardware_udelay" or something all over the kernel
> would have delayed the paravirt_ops merge by an infinite amount 8)

And here you claim you could not do the right thing, because people
would notice you are doing huge search/replace without audit, and
would stop you. So you simply hidden it from them :-(.

Plus... udelay() should just work under virtualization, right? You get
slightly slower kernel, but still working, so the "full audit" is not
as hard as you are telling me.

Just replace udelay() with hardware_udelay() on places that matter in
your workload...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
