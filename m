Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbYHFT2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbYHFT2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYHFT16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:27:58 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:37361 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYHFT16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:27:58 -0400
Date: Wed, 6 Aug 2008 21:28:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080806192842.GB17227@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <200808051418.05324.rusty@rustcorp.com.au> <20080805204548.GD5464@uranus.ravnborg.org> <20080805220615.GC18607@flint.arm.linux.org.uk> <20080806192126.GA29891@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806192126.GA29891@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 08:21:26PM +0100, Russell King wrote:
> On Tue, Aug 05, 2008 at 11:06:15PM +0100, Russell King wrote:
> > Currently, I know Linus' tree builds fine for most ARM platforms (thanks
> > to the ARM kautobuild project.)  However, I'm seeing unexpected build
> > failures that don't make sense from the linux-next project.
> 
> And the expression "oh bugger" comes to mind.  The breakage in linux-next
> is because of 2e57d051160dd61776461637f767df19036b1186 and
> ea35455e0dc17d732436a5b98bd511cab64eb10e.
> 
> During the last fortnight, I'd moved the "easy to move" ARM headers
> from include/asm-arm to arch/arm/include/asm.  This means that, unknown
> to me, the symlink was no longer being created.  That didn't get picked
> up in my testing, because I always build using O= builds into already
> existing object trees, which of course all have the symlink in place.
> 
> This doesn't affect kautobuild because that always builds trees without
> using the O= facility.
> 
> The question is what to do about it.  Given the size of the task, I'm
> currently of the opinion that we're moving things around in the wrong
> order, and 4baa9922430662431231ac637adedddbb0cfb2d7 should be reverted
> until we've moved all the other ARM headers (in asm/arch and asm/plat-*)
> first.

Our mails crossed. I will fix kbuild asap so you do not need to revert.

	Sam
