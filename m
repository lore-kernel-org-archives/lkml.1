Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYBSFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYBSFcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 00:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYBSFcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 00:32:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36287 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYBSFcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 00:32:22 -0500
Date: Tue, 19 Feb 2008 06:32:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080219053229.GB25680@uranus.ravnborg.org>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802190017.04432.mb@bu3sch.de> <20080218234212.GA25680@uranus.ravnborg.org> <200802190101.27429.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190101.27429.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > It is a consistencycheck between host and target
> > layout of data.
> > You need to pad the structure so it becomes 8 byte in size.
> 
> Ok, I looked at the code and it is hightly questionable to me that this
> check does work in a crosscompile environment (which the ARM build
> most likely is).
> 
> It seems to check the size of the structure in the .o file against
> the size of the structure on the _host_ where it is compiled.
> I can't see why we would want to check _anything_ of the target stuff
> to the host this stuff is compiled on.
> I can compile an ARM kernel on any machine I want.
> 
> There actually is a comment:
>  * Check that sizeof(device_id type) are consistent with size of section
>  * in .o file. If in-consistent then userspace and kernel does not agree
>  * on actual size which is a bug.
> 
> So it seems what this check _wants_ to compare the sizeof the structure
> in the kernel to the size of the stucture in the userland of the target system.
> But it does _not_ do that.
> It does compare the size of the structure in the kernel against the size of
> the stucture in userland on the machine it is _compiled_ on.
> That is wrong.
In at least 99% of the cases this is OK and the check has found
several bugs where things would not have worked due to different
alignmnet between kernel and userland. Just think about the
issues in a mixed 32/64 bit world.

In this particular case you _could_ be right that it would work
on ARM userland. But the only way to be sure is to pad the
structure so it become 8 byte in size.
Or as was recently done in the m68k case to tell the
compiler to specifically align it to 8 byte boundary.

	Sam
