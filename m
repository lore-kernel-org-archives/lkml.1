Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbYHEWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbYHEWH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYHEWGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:06:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56120 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYHEWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:06:38 -0400
Date: Tue, 5 Aug 2008 23:06:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080805220615.GC18607@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <200808051418.05324.rusty@rustcorp.com.au> <20080805204548.GD5464@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805204548.GD5464@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 10:45:48PM +0200, Sam Ravnborg wrote:
> On Tue, Aug 05, 2008 at 02:18:05PM +1000, Rusty Russell wrote:
> > On Tuesday 29 July 2008 06:05:00 Sam Ravnborg wrote:
> > > is is suggested to move the arch specific files under arch/
> > > and for the header files this is arch/$ARCH/include.
> > 
> > Well, it would have been nice to take the opportunity to separate user-visible 
> > header files and non-user-visible files.  We could have left the user-visible 
> > ones in place, for example: diffstat would then show when you were frobbing 
> > the userspace interface.
> 
> I would like to see this change too - but intentionally I would
> not try to mix it with the move of the header files. Lets get the
> move done now and fix the fall-outs, then we can take this logical
> next step.

Absolutely agreed.

Some architectures (eg, ARM) have quite a large headache to solve with
these changes.

Currently, I know Linus' tree builds fine for most ARM platforms (thanks
to the ARM kautobuild project.)  However, I'm seeing unexpected build
failures that don't make sense from the linux-next project.

I've just wound my tree back to a "pristine" state for linux-next, and
plan to wait for its next build to check whether its me or something else
causing it.  What I'm referring to is:

s3c2410_defconfig's showing:
include/asm/arch/map.h:16:30: error: asm/plat-s3c/map.h: No such file or directory

which, if its including it via include/ shouldn't be happening because
plat-s3c hasn't moved from include/asm(-arm)/, the same as
include/asm-arm/arch-s3c2410 hasn't moved in linux-next yet.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
