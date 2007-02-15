Return-Path: <linux-kernel-owner+w=401wt.eu-S965767AbXBOKRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767AbXBOKRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965769AbXBOKRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:17:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45051 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965767AbXBOKRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:17:37 -0500
Date: Thu, 15 Feb 2007 11:17:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070215101713.GK26240@elf.ucw.cz>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain> <20070214125216.2befda78@localhost.localdomain> <45D36B49.5090109@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D36B49.5090109@vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>We'd have to audit and figure out what udelays are for hardware and
> >>which are not, but the evidence is that the vast majority of them are
> >>for hardware and not needed for virtualization.
> >>    
> >
> >Which is irrelevant since the hardware drivers won't be used in a
> >virtualised environment with any kind of performance optimisation.
> >  
> 
> Which is why an audit is irrelevant for the most part.  Note on the 
> performance below.

You know it is ugly. Alan demonstrated it even hurts performance, but
being ugly is the main problem.

If you _need_ to avoid udelay() in some cases, introduce
udelay_unless_virtualized(), and switch few users to it. Just globaly
defining udelay to nop is _ugly_.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
