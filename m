Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZBHFv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZBHFv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 00:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZBHFvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 00:51:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZBHFvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 00:51:48 -0500
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090206172453.GB11299@uranus.ravnborg.org>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
	 <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
	 <20090205191907.GA27422@elte.hu>
	 <1233886017.3463.26.camel@localhost.localdomain>
	 <20090206022025.GA8317@elte.hu>
	 <1233929922.3209.6.camel@localhost.localdomain>
	 <20090206172453.GB11299@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 11:20:34 +0530
Message-Id: <1234072234.26182.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 18:24 +0100, Sam Ravnborg wrote:
> > 
> > Is this safe OR we can make it more safer:
> > 
> > Subject: [PATCH] make linux/types.h as assembly safe
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  include/linux/types.h |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index 712ca53..c30973a 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -1,6 +1,7 @@
> >  #ifndef _LINUX_TYPES_H
> >  #define _LINUX_TYPES_H
> >  
> > +#ifndef __ASSEMBLY__
> >  #ifdef	__KERNEL__
> >  
> >  #define DECLARE_BITMAP(name,bits) \
> > @@ -212,5 +213,5 @@ struct ustat {
> >  };
> >  
> >  #endif	/* __KERNEL__ */
> > -
> > +#endif /*  __ASSEMBLY__ */
> >  #endif /* _LINUX_TYPES_H */
> 
> This is wrong...
> We should include the assumed assembly safe asm/types.h
> outside the __ASEMBLY__ ifdef.
> 

The following changes since commit f6c727813e03ce0f58d73808da8c9a6bc227249e:
  Ingo Molnar (1):
        Merge branch 'core/header-fixes' of git://git.kernel.org/.../jaswinder/linux-2.6-tip into core/header-fixes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes

Jaswinder Singh Rajput (1):
      unconditionally include asm/types.h from linux/types.h

 include/linux/types.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Complete diff:
diff --git a/include/linux/types.h b/include/linux/types.h
index c30973a..fca82ed 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_TYPES_H
 #define _LINUX_TYPES_H
 
+#include <asm/types.h>
+
 #ifndef __ASSEMBLY__
 #ifdef	__KERNEL__
 
@@ -10,7 +12,6 @@
 #endif
 
 #include <linux/posix_types.h>
-#include <asm/types.h>
 
 #ifndef __KERNEL_STRICT_NAMES
 


