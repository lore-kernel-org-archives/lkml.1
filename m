Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXIXVfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXIXVfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXIXVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:34:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55088 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXIXVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:34:56 -0400
Date: Mon, 24 Sep 2007 23:36:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070924213622.GA6745@uranus.ravnborg.org>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F78C73.5040505@linux.vnet.ibm.com> <20070924210222.GA4595@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924210222.GA4595@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 11:02:22PM +0200, Sam Ravnborg wrote:
> Hi Kamalesh.
> 
> > The link error for a PowerMac G5 (powerpc) is still seen with 
> > 2.6.23-rc7-mm1,
> > and was reported for 2.6.23-rc6-mm1 (http://lkml.org/lkml/2007/9/19/62).
> > 
> >  KSYM    .tmp_kallsyms1.S
> >  AS      .tmp_kallsyms1.o
> >  LD      .tmp_vmlinux2
> >  KSYM    .tmp_kallsyms2.S
> >  AS      .tmp_kallsyms2.o
> >  LD      vmlinux.o
> > ld: dynreloc miscount for fs/built-in.o, section .opd
> > ld: can not edit opd Bad value
> > make: *** [vmlinux.o] Error 1
> 
> Can you try to narrow it down a bit further...
> As this happens when building fs/built-in.o it should be
> straightforward to do so.
> 
> First step would be to do:
> rm fs/built-in.o
> make fs/ V=1
> 
> Then copy the ld invocation and try to remove the input .o files one-by-one.
> This should tell you which .o file is causing the bug.
> 
> Next step is to try to squeze down the offending file until the
> errornous part remains.
> 
> Last time I did a
> make fs/file.i
> 
> And then I used gcc & ld to compile and link.
> Gradually removing stuff from file.i made me spot the problem
> with the weak prototype in a header file.
> 
> I guess something else is making ld hit this error now.
> 
> PS. Just reinstalled my dev box so no crosscompiler atm.

Got powerpc toolchain running now but cannot reproduce.
What config do you use (I used g5_defconfig)?
And what ld version?

	Sam
