Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXI3K15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXI3K15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXI3K1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:27:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:32871 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXI3K1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:27:50 -0400
Date: Sun, 30 Sep 2007 12:29:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Extending kbuild syntax
Message-ID: <20070930102903.GA12747@uranus.ravnborg.org>
References: <20070929201145.GA20377@uranus.ravnborg.org> <20070930030258.GA10852@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930030258.GA10852@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 05:02:58AM +0200, Adrian Bunk wrote:
> On Sat, Sep 29, 2007 at 10:11:45PM +0200, Sam Ravnborg wrote:
> >...
> > The second is the more controversial suggestion.
> > In several Makefile we have simple if expression of the variants:
> > if ($(CONFIG_FOO),y)
> >   obj-$(CONFIG_BAR) += fubar.o
> > endif
> > 
> > The pattern varies over this theme.
> > The suggestion here is to introduce a few helpers:
> > 
> > obj-y-if-$(CONFIG_FOO) += fubar.o
> > This one shall read:
> > if $(CONFIG_FOO) is y or m then set += to obj-y
> 
> IMHO for people who are not kbuild junkies the pattern is more clear 
> with the current syntax.
> 
> But you should better ask some guinea pigs who have not already seen as 
> many kernel Makefiles as I have...

Target group are for kernel developers and people who have
actually read Documentation/kbuild/makefiles.txt

But point taken - this is too 'magic'.
I will try to think of something that looks a bit more straightforward.

> Some of the cases have the following pattern:
> 
> config X86_POWERNOW_K8_ACPI
>         bool
>         depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
>         depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
>         default y
> 
> Your suggested syntax has to be enhanced with three additional
> variables for handling such cases.
> 
> 
> The complicated cases can be handled either in kconfig or in kbuild,
> and I think kconfig is the better place for them:

The kbuild enhancements are for the cases where it
makes less sense to express this in Kconfig.
They are not thought as replacing Kconfig dependencies in any way.

I will try to come up with a new proposal later today.

	Sam
