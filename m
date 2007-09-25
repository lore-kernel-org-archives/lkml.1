Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXIYTWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXIYTWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXIYTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:21:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49988 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbXIYTVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:21:52 -0400
Date: Tue, 25 Sep 2007 21:22:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Henry Nestler <Henry.Ne@Arcor.de>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
Message-ID: <20070925192250.GA14689@uranus.ravnborg.org>
References: <46F8D9B8.3090806@Arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F8D9B8.3090806@Arcor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henry.

On Tue, Sep 25, 2007 at 11:49:44AM +0200, Henry Nestler wrote:
> In reference of git 114f51577724b782a30f4f5ceaee9880de93d776:
> >    kbuild: use LDFLAGS_MODULE only for .ko links
> >    
> >    Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt 
> >    already
> >    says this is what it's for.  This patch makes the reality live up to 
> >    the
> >    documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting 
> >    into too
> >    many places.
> 
> LDFLAGS_MODULE is not usable in module build out of kernel tree since
> 2.6.23-rc2. LDFLAGS_$@ should use, but does never work. - Not for
> external module builds with the option "M=..."

LDFLAGS_MODULE are reserved for architectures and modules be external
or not should never ude LDFLAGS_MODULE.
And LDFALGS_$@ have never been documented to work for modules - dunno
where you have that from.
IIRC we only use LDFALGS_$@ in the ld macro to be used by bootloaders.

> 
> What macro should set for linker parameters of foo.o ? I'm not shure.
Have you read:
Documentation/kbuild/makfilefiles.txt?
Here it is documented how to use the relevant variables.

> Currently found, that only LDFLAGS is usable. But, found LDFLAGS in
> modpost calls, there also exist a --start-group/--end-group. Is it right
> to use it for external module?
LDFLAGS are a kernel wide variable. Modules shall not fiddle with it!


>From your description you want to add a specific set of options to
the linker in a specific Kbuild file.
This is what EXTRA_LDFLAGS are present to help you with.

As for the:
> # Deal with recursive depens of libraries
I am not sure what you mean (despite yout comprehensive description).
Please try if EXTRA_LDFLAGS := --start-group lib.a --end-group
will solve your need.

I'm afraid not due to the placement of the --start-group --end-group.
If this does not help you please give me specific examples of how
the ld command-line should be then I can see how we tweak kbuild
to help you.

	Sam
