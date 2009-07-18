Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZGRG7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZGRG7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZGRG7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:59:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56041 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZGRG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:59:05 -0400
Date: Sat, 18 Jul 2009 08:59:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, barryn@pobox.com
Subject: Re: [PATCH,v2] Only add '-fwrapv' to gcc CFLAGS for gcc 4.2 and
	later
Message-ID: <20090718065903.GA7579@merkur.ravnborg.org>
References: <200907100928.07369.elendil@planet.nl> <200907102205.49642.elendil@planet.nl> <20090717221846.GA7347@merkur.ravnborg.org> <200907180043.53257.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907180043.53257.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 12:43:51AM +0200, Frans Pop wrote:
> On Saturday 18 July 2009, Sam Ravnborg wrote:
> > >  # disable invalid "can't wrap" optimizations for signed / pointers
> > > -KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
> > > +KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0402 ]; then \
> > > +		    echo $(call cc-option,-fwrapv); fi ;)
> >
> > This would be simpler if you use:
> 
> That's now academic as Linus decided on a different fix.
OK

> 
> > # cc-ifversion
> > # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
> > cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))
> >
> > We have only one user at the moment so I understand why you missed it.
> 
> :-)
> 
> I based my patch on arch/x86/Makefile:
> 35:        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
> 36:                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
> 
> Guess that could be improved to use cc-ifversion then.
Yes, please...

> 
> And a quick git grep gives a few other potential candidates:
> arch/ia64/Makefile:44:ifeq ($(call cc-version),0304)
> arch/parisc/Makefile:129:       @if test "$(call cc-version)" -lt "0303"; then \
> arch/powerpc/Makefile:80:GCC_BROKEN_VEC := $(shell if [ $(call cc-version) -lt 0400 ] ; then echo "y"; fi)
> arch/powerpc/Makefile:219:      @if test "$(call cc-version)" = "0304" ; then \
> arch/um/Makefile-i386:38:KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
Same goes for these.

	Sam
