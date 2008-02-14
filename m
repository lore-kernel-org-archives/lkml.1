Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbYBNVLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbYBNVLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763808AbYBNVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:11:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35111 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763501AbYBNVLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:11:09 -0500
Date: Thu, 14 Feb 2008 22:11:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unhide CONFIG_DEBUG_SECTION_MISMATCH
Message-ID: <20080214211117.GH21894@uranus.ravnborg.org>
References: <20080214210003.GF21894@uranus.ravnborg.org> <200802142105.m1EL5EOo006085@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802142105.m1EL5EOo006085@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 04:05:14PM -0500, Erez Zadok wrote:
> In message <20080214210003.GF21894@uranus.ravnborg.org>, Sam Ravnborg writes:
> > On Thu, Feb 14, 2008 at 03:54:04PM -0500, Erez Zadok wrote:
> > > Using: v2.6.25-rc1-120-ge760e71
> > > 
> > > In a normal compilation, I might this message:
> > > 
> > > ...
> > >   MODPOST vmlinux.o
> > > WARNING: modpost: Found 4 section mismatch(es).
> > > To see full details build your kernel with:
> > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > > ...
> > > 
> > > I can indeed try to re-make, passing CONFIG_DEBUG_SECTION_MISMATCH=y on the
> > > command line, but I can't turn on the option in my .config.  That's because
> > > the option depends on "UNDEFINED".  (Was that an attempt to "hide" the
> > > option?  Why?)  The following small patch allows me to set the option in my
> > > .config.
> > 
> > It was done so on purpose.
> > The rationale here is that we yet have too many section mismatch for
> > a typical build to pass my "good stomach" test.
> > So until we get down on an acceptable level we should not be
> > too noisy.
> > And I wanted it to be turned off also for allyesconfig builds.
> > 
> > I hope to spend time on the reaming warnings soon but the
> > option will not be enabled until latest next mergewindow.
> > 
> > You could argue that I could have doen this in better ways
> > The present version was just simple.
> > 
> > 	Sam
> 
> Thanks, Sam.  That explains it.  Perhaps a small comment next to the Kconfig
> entry might help explain why the option is "hidden" for now, so others won't
> bother unhiding it again.

Something like this?
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..8a6b514 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -81,6 +81,8 @@ config HEADERS_CHECK

 config DEBUG_SECTION_MISMATCH
        bool "Enable full Section mismatch analysis"
+# Hide this option until we are down to a reasonable amount of warnings
+# for a typical kernel configuration
        depends on UNDEFINED
        help


	Sam
