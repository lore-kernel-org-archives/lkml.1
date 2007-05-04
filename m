Return-Path: <linux-kernel-owner+w=401wt.eu-S1031360AbXEDJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031360AbXEDJqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031368AbXEDJqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:46:49 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41679 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031361AbXEDJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:46:48 -0400
Date: Fri, 4 May 2007 11:47:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
Subject: Re: build system: no module target ending with slash?
Message-ID: <20070504094740.GA23800@uranus.ravnborg.org>
References: <200705030043.49208.mail@earthworm.de> <200705030917.19630.mail@earthworm.de> <20070503193736.GA18216@uranus.ravnborg.org> <200705041056.19286.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705041056.19286.mail@earthworm.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 10:56:14AM +0200, Christian Hesse wrote:
> Agreed that it is not really needed. But if you don't build it you should not 
> try to link it later...
> 
> > The quick-and-dirty workaround is to add a single
> > obj-n := xx
> > in mac80211/Makefile and kbuild is happy again.
> >
> > I could teach kbuild to create built-in.o also in the case
> > where we refer to a subdirectory only. But then we would end up with a
> > built-in.o in all directories where we have a kbuild MAkefile (almost) and
> > that is not desireable.
> 
> I would prefer to teach it not to link object files that are not built.

But you already _told_ kbuild that mac80211/ would contain a built-in.o
using following statement in drivers/net/wireless/Makefile:
obj-y += mac80211/

Changing this to obj-$(CONFIG_IWLWIFI) += mac80211/ would
give kbuild the _correct_ info.

obj-m += dir/
tell kbuild this directory contains a module so it will descend and build
obj-y += dir/
tall kbuild that directory contains stuff to be built-in and _maybe_ a module so
it will descend and build.

Note that when kbuild has entered a subdirectory it has lost knowledge of _how_
it came there so if you have lied to kbuild it will not detect it.
So in your case you told kbuild that there is stuff to be build in
in the mac80211/ dir which was incorrect.

	Sam
