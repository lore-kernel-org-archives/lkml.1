Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXCOHe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXCOHe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbXCOHe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:34:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36413 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbXCOHez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:34:55 -0400
Date: Thu, 15 Mar 2007 00:33:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Len Brown <lenb@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 16/20] acpi files switched
Message-ID: <20070315073336.GY10574@sequoia.sous-sol.org>
References: <20070315051337.488091591@goodmis.org> <20070315051532.400874263@goodmis.org> <200703150236.43214.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703150236.43214.lenb@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown (lenb@kernel.org) wrote:
> On Thursday 15 March 2007 01:13, Steven Rostedt wrote:
> > Moved the shared files that were in arch/i386/kernel/acpi to the common
> > area.
> 
> When I do a "make cscope" on an i386 or an x86_64 box,
> will it find these files in the common area?

The simple equiv of 'make ALLSOURCE_ARCHS="$ARCH x86" cscope'
should do it.  I'm sure there's a slicker way, but this
brute force gives you an idea:


--- a/Makefile	Mon Mar 12 11:07:45 2007 -0700
+++ b/Makefile	Thu Mar 15 00:32:25 2007 -0700
@@ -1266,6 +1266,12 @@ ifeq ($(ALLSOURCE_ARCHS),)
 ifeq ($(ALLSOURCE_ARCHS),)
 ifeq ($(ARCH),um)
 ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
+else ifeq ($(ARCH),i386)
+ALLINCLUDE_ARCHS := x86 $(ARCH)
+ALLSOURCE_ARCHS := x86 $(ARCH)
+else ifeq ($(ARCH),x86_64)
+ALLINCLUDE_ARCHS := x86 $(ARCH)
+ALLSOURCE_ARCHS := x86 $(ARCH)
 else
 ALLINCLUDE_ARCHS := $(ARCH)
 endif
@@ -1274,7 +1280,7 @@ ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
 endif
 
-ALLSOURCE_ARCHS := $(ARCH)
+ALLSOURCE_ARCHS ?= $(ARCH)
 
 define find-sources
         ( find $(__srctree) $(RCS_FIND_IGNORE) \
