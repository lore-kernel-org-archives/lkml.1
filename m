Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbXKUHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbXKUHKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXKUHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:10:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXKUHKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:10:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] x86 vDSO: vdso32 build
In-Reply-To: Sam Ravnborg's message of  Wednesday, 21 November 2007 07:02:01 +0100 <20071121060201.GA32304@uranus.ravnborg.org>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220532.029FC26F8BE@magilla.localdomain>
	<20071121060201.GA32304@uranus.ravnborg.org>
X-Shopping-List: (1) Obvious dice
   (2) Victorious assumption yies
   (3) Reticent confirmers
Message-Id: <20071121071015.B8E3A26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 23:10:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +# This makes sure the $(obj) subdirectory exists even though vdso32/
> > +# is not a kbuild sub-make subdirectory.
> > +override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
> 
> Should we teach kbuild to create dirs specified in targets?
> Or we could 'fix' it so you do not need the override.

Something cleaner would be nice, yes.  I'll leave it to you to decide.

> use "set -e; in front of this shell script to bail out early
> in case of errors.

Back when I knew something about make, all commands ran with sh -ec.
Ah, progress.  Anyway, the one you cited does not have any commands that
aren't tested with && or if already.  set -e would have no effect.

> > +VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
> 
> Do you need to specify soname for 64-bit - seems missing?

Using this rule for the 64-bit vDSO is not in this patch.
Patch 18/18 defines VDSO_LDFLAGS_vdso.lds for this.

> > +$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
> >  	@mkdir -p $(MODLIB)/vdso
> >  	$(call cmd,vdso_install)
> Please use $(Q) in preference for @
> Then it is easier to debug using make V=1

This line is not being changed in this patch, so that is really a separate
question.  Other places in other Makefiles use @mkdir too, so if you are
concerned you could do a patch covering all of those.


Thanks,
Roland
