Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXIZLAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXIZLAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXIZLAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:00:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58572 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXIZLAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:00:04 -0400
Date: Wed, 26 Sep 2007 13:01:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Henry Nestler <Henry.Ne@Arcor.de>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
Message-ID: <20070926110130.GA20950@uranus.ravnborg.org>
References: <46F8D9B8.3090806@Arcor.de> <20070925192250.GA14689@uranus.ravnborg.org> <46FA2CC0.2000204@Arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA2CC0.2000204@Arcor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>What macro should set for linker parameters of foo.o ? I'm not shure.
> >Have you read:
> >Documentation/kbuild/makfilefiles.txt?
> 
> Yes. This was a *very* helpfull. And many examples spokes about 
> LDFLAGS_$@ there. Not directly described for modules.

Took a deeper look.
I saw one reference to LDFLAGS_$@ that is wrong:
    LDFLAGS             Generic $(LD) options

        Flags used for all invocations of the linker.
        Often specifying the emulation is sufficient.

        Example:
                #arch/s390/Makefile
                LDFLAGS         := -m elf_s390
        Note: EXTRA_LDFLAGS and LDFLAGS_$@ can be used to further customise
        the flags used. See chapter 7.

The chapter reference is also bad...
The other references to the LDFLAGS_$@ are in other situations - it is
used in several places.

If your example requires the LDFALGS_$@ I wil introduce it - for now
it has not been required (except for vdso support where it was hacked).

	Sam
