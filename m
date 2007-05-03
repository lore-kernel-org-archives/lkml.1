Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXECGOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXECGOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXECGOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:14:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43283 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbXECGOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:14:40 -0400
Date: Thu, 3 May 2007 08:15:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
Subject: Re: build system: no module target ending with slash?
Message-ID: <20070503061533.GA13399@uranus.ravnborg.org>
References: <200705030043.49208.mail@earthworm.de> <20070503042511.GB12644@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503042511.GB12644@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 06:25:11AM +0200, Sam Ravnborg wrote:
> On Thu, May 03, 2007 at 12:43:43AM +0200, Christian Hesse wrote:
> > Hi James, hi everybody,
> > 
> > playing with iwlwifi I try to patch it into the kernel and to build it from 
> > there. But I have a problem with the build system.
> > 
> > The file drivers/net/wireless/mac80211/Makefile contains one single line:
> > 
> > obj-$(CONFIG_IWLWIFI)   += iwlwifi/
> > 
> > When CONFIG_IWLWIFI=m in scripts/Makefile.lib line 29 the target is filtered 
> > as it ends with a slash. That results in 
> > drivers/net/wireless/mac80211/built-in.o not being built and the build 
> > process breaks with an error. What is the correct way to handle this? Why are 
> > targets ending with a slash filtered?
> 
> Looks buggy. I will take a look tonight.
After some coffee...

Line 29 in Kbuild.include find all modules and a directory is not a module.
In line 26 in same file the directory iwlwifi is included in the list
of directories to visit.
So there is something else going on.

Anywhere I can get access to the combined source or could you try to post the full
Makefile.

	Sam
