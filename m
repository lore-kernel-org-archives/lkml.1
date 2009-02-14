Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZBNTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZBNTz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 14:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZBNTzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 14:55:14 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54104 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZBNTzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 14:55:12 -0500
Date: Sat, 14 Feb 2009 20:57:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as possible
Message-ID: <20090214195702.GB1241@uranus.ravnborg.org>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru> <20090204212612.GN22608@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204212612.GN22608@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 10:26:12PM +0100, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This patch gives arches more freedom on overwriting CFLAGS, specifically
> > on PowerPC we want to remove -fno-omit-frame-pointer flag.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  Makefile |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 7715b2c..d1ba93f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -525,8 +525,6 @@ else
> >  KBUILD_CFLAGS	+= -O2
> >  endif
> >  
> > -include $(srctree)/arch/$(SRCARCH)/Makefile
> > -
> >  ifneq (CONFIG_FRAME_WARN,0)
> >  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
> >  endif
> > @@ -555,6 +553,8 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
> >  KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
> >  endif
> >  
> > +include $(srctree)/arch/$(SRCARCH)/Makefile
> > +
> >  # arch Makefile may override CC so keep this after arch Makefile is included
> >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
> >  CHECKFLAGS     += $(NOSTDINC_FLAGS)
> > -- 
> 
> this patch is really for Sam to judge - Cc:-ed him.

If we move the include further down then the following:

    # Force gcc to behave correct even for buggy distributions
    # Arch Makefiles may override this setting
    KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)

will most likely fail.

If popwerpc needs to get rid of "-fno-omit-frame-pointer" then
we need a way to express this at KConfig level and NOT by doing
some tricks with CFLAGS.

	Sam
