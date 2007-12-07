Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbXLGFMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbXLGFMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXLGFMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:12:34 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46613 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLGFMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:12:33 -0500
Date: Fri, 7 Dec 2007 06:14:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
Message-ID: <20071207051420.GA27989@uranus.ravnborg.org>
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com> <47565486.8050701@gmail.com> <20071205190609.GA14997@uranus.ravnborg.org> <47573403.1060203@gmail.com> <20071206223754.GB25209@uranus.ravnborg.org> <47589AF4.6080708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47589AF4.6080708@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >>> And this change in Makefile.lib seems bogus:
> >>> +# make sure '/' follows subdirs
> >>> +subdir-y       := $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
> >>> +subdir-m       := $(patsubst %//,%/, $(addsuffix, /,$subdir-m))
> >> Some subdir-y|m entries have following / while others don't.  subdir-y|m
> >> are lax about because either way it points to subdirectory.  The above
> >> two lines are to normalize them so that there's no surprises when
> >> concatenating file name to it.  I think it's a good idea to have the
> >> above with or without other changes.
> > With this change building modpost no longer worked so kbuild
> > does not like the preceeding slashes. It could be fixed but thats
> > another patch.
> 
> I don't really follow what you mean here.  Do you mean with the tailing
> slash normalized, modpost doesn't work anymore?  Or with the
> normalization removed?
I a mrproper tree I did:
make defconfig
make

And it failed because modpost were never built - because the directory
scripts/mod/ was never visited.

> 
> >>> subdir-y and subdir-m does not point to directories that
> >>> contains modules (built-in or not) so they can be ignored for modorder.
> >> I didn't know that.  Is it forced that modules can't be put in
> >> subdir-y|m directories?  What happens if I do that?
> > 
> > I guess modules can be built as modules - but they can never be built-in.
> > And if someone uses subdir-y to point to a dir with modules
> > I would anyway cosider that a bug.
> 
> s/module/component which can be a dynamically loadable module or
> built-in to the kernel/ in my original sentence.  I just couldn't find a
> good word to use.  So, you're saying subdir-ym's can be dropped from
> modorder, right?
Correct - my patch did so.

> It would be great if we can implement a safeguard to
> check that subdif-ym's don't actually contain modules.
Could be a good idea - will think about it.

	Sam
