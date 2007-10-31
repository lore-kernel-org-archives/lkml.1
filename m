Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXJaJk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXJaJk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXJaJkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:40:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48510 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbXJaJkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:40:17 -0400
Date: Wed, 31 Oct 2007 10:41:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 32bit builds on x86-64 host.
Message-ID: <20071031094148.GA24100@uranus.ravnborg.org>
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com> <20071030131032.GA32366@infradead.org> <4727D391.6080603@goop.org> <20071031085739.GA5468@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031085739.GA5468@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 08:57:39AM +0000, Christoph Hellwig wrote:
> On Tue, Oct 30, 2007 at 06:00:01PM -0700, Jeremy Fitzhardinge wrote:
> > Christoph Hellwig wrote:
> > > Which seems rather unnatural to me.  All other merge architectures have
> > > ARCH=<archdir> where archdir is the name under arch, e.g. mips, powerpc,
> > > s390.  They then have a CONFIG_FOO_64 and set the utsname and -m32/-m64
> > > respectively.  It would be nice if x86 could behave like all other
> > > architectures in this respect.  Especially as the behaviour of the other
> > > architectures is a lot more intuitive.
> > >   
> > 
> > Yes, that would be nice.  I keep forgetting the ARCH= in my crossbuild
> > trees, and end up with strange mismashes.
> 
> That's a problem with all architectures currently.  But I think Sam has
> a patch that at least stores ARCH when using objdir != srcdir builds.
kbuild check's the asm symlink and error out if it is wrong.
So forgetting ARCH should be captured. But the check does not
store ARCH which is what I hope to have fixed for next merge window.

So for now if you forget ARCH you should be warned.
And in the future kbuild will remember what ARCH (and CROSS_COMPILE)
you used when configuring the kernel.

For x86 the current check does not help use because the asm symlink
is the same for i386 and x86_64 - so for now we are out of luck.

	Sam
