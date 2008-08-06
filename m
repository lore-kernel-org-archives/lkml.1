Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbYHFTWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbYHFTWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYHFTV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:21:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53195 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbYHFTV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:21:57 -0400
Date: Wed, 6 Aug 2008 20:21:26 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080806192126.GA29891@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <200808051418.05324.rusty@rustcorp.com.au> <20080805204548.GD5464@uranus.ravnborg.org> <20080805220615.GC18607@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805220615.GC18607@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:06:15PM +0100, Russell King wrote:
> Currently, I know Linus' tree builds fine for most ARM platforms (thanks
> to the ARM kautobuild project.)  However, I'm seeing unexpected build
> failures that don't make sense from the linux-next project.

And the expression "oh bugger" comes to mind.  The breakage in linux-next
is because of 2e57d051160dd61776461637f767df19036b1186 and
ea35455e0dc17d732436a5b98bd511cab64eb10e.

During the last fortnight, I'd moved the "easy to move" ARM headers
from include/asm-arm to arch/arm/include/asm.  This means that, unknown
to me, the symlink was no longer being created.  That didn't get picked
up in my testing, because I always build using O= builds into already
existing object trees, which of course all have the symlink in place.

This doesn't affect kautobuild because that always builds trees without
using the O= facility.

The question is what to do about it.  Given the size of the task, I'm
currently of the opinion that we're moving things around in the wrong
order, and 4baa9922430662431231ac637adedddbb0cfb2d7 should be reverted
until we've moved all the other ARM headers (in asm/arch and asm/plat-*)
first.

Maybe even leaving this until the next merge window now that -rc2 is
out would be a good idea.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
