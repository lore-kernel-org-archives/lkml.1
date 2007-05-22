Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXEVJG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXEVJG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXEVJGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:06:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38466 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755131AbXEVJGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:06:47 -0400
Date: Tue, 22 May 2007 11:06:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070522090636.GO10714@elf.ucw.cz>
References: <1179604609.16465.83.camel@sublime.suse.de> <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522003153.GA18162@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So don't do it badly. The advantage of doing so is that you can make it 
> > > work properly, which you can't by putting it in the kernel.
> > 
> > You want stuff like critical shutdowns to work even if userspace is
> > dead.
> 
> I don't think anyone suggested putting the critical shutdown control in 
> userspace. The kernel already handles that fine.

No it does not. That is what this thread is about.

(On old xe3, critical trip point set by BIOS is ~95C, but machine dies
by hw safeguard at ~83C. Workaround is to lower critical trip point to
80C or so. Len broke this.)

> Imagine the following situation:
> 
> 1) Platform sets critical shutdown trip point to 85C
> 2) Userspace sets critical shutdown trip point to 95C
> 3) Temperature reaches 90C
> 4) Platform forces reevaluation of trip points
> 5) Entire invasion fleet is lost
> 
> How do you avoid that? Disable the ability for the platform to set trip 
> points? You're breaking the spec and potentially causing hardware 

We need to ignore trip point updates from BIOS, and we need to poll
thermals when use overrides trip points. That's expected. Plus I've
yet to see platform actually updating the trip points.

Speaking about hw damage... The broken BIOS on xe3 definitely caused
damage to its harddrive, so... we are preventing hw damage here.

(Plus, Len's patch broke user-kernel in stable series, without warning).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
