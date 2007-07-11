Return-Path: <linux-kernel-owner+w=401wt.eu-S934491AbXGKXET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbXGKXET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXGKXDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:03:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782AbXGKXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:03:49 -0400
Date: Wed, 11 Jul 2007 16:03:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
Message-Id: <20070711160335.8705f742.akpm@linux-foundation.org>
In-Reply-To: <20070711224327.9B0ED4D0555@magilla.localdomain>
References: <46955BB1.20200@windriver.com>
	<20070711224327.9B0ED4D0555@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 15:43:27 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> > The -gdwarf2 had a specific reason. 
> 
> I have no objection to it.  
> 

OK, thanks.  So I ended up with the below as a probably-2.6.23 thing:


From: Roland McGrath <roland@redhat.com>

The assembler for a while now supports -gdwarf to generate source line info
just like the C compiler does.  Source-level assembly debugging sounds like an
oxymoron, but it is handy to be able to see the right source file and read its
comments rather than just the disassembly.  This patch enables -gdwarf for
assembly files when CONFIG_DEBUG_INFO=y and the assembler supports the option.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN Makefile~pass-g-to-assembler-under-config_debug_info Makefile
--- a/Makefile~pass-g-to-assembler-under-config_debug_info
+++ a/Makefile
@@ -498,6 +498,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
+AFLAGS		+= $(call as-option, -gdwarf)
 endif
 
 # Force gcc to behave correct even for buggy distributions
_


If there are problems it'll most likely be with oddball architectures
running older compilers, I guess.  If something blows up we might need to
make this an arch/foo/Makefile thing.

