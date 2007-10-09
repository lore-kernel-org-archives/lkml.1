Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXJIQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXJIQdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXJIQdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:33:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41396 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXJIQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:33:06 -0400
Date: Tue, 9 Oct 2007 18:34:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009163435.GA25408@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <p73sl4k4ofq.fsf@bingen.suse.de> <20071009100030.GA22475@uranus.ravnborg.org> <20071009140906.GA4942@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009140906.GA4942@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 10:09:06AM -0400, Jeff Dike wrote:
> On Tue, Oct 09, 2007 at 12:00:30PM +0200, Sam Ravnborg wrote:
> > If it is OK to drop the $(SUBARCH) assingment like this then yes.
> > ARCH		?=
> > CROSS_COMPILE	?=
> 
> Does the UML build still work when you do that?

The original behaviour is kept is ARCH is not set on the
commandline and saved in .kbuild (Kbuild.config in the patch).

The logic goes basically like this:
If there is no .kbuild file then set ARCH = $(SUBARCH)
else set ARCH = saved ARCH from .kbuild.

And then a bit sanity check that the user does not
try to change architecture in the middle.

I actually used um as testing ground for this patch so
it works for um in my way of building um.

I considered switching architectures automagically
but concluded that in most cases when a user change ARCH
then that's because the user forgot to specify ARCH or more
seldom forgot what ARCH was being built in that directory.

	Sam
