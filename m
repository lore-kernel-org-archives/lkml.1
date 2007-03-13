Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXCMGif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXCMGif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXCMGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:38:34 -0400
Received: from ozlabs.org ([203.10.76.45]:33242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXCMGie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:38:34 -0400
Subject: Re: CONFIG_REORDER Kconfig help strange sentence.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@infradead.org
In-Reply-To: <20070312235605.GA14444@muc.de>
References: <1173741484.10618.25.camel@localhost.localdomain>
	 <20070312235605.GA14444@muc.de>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 17:37:35 +1100
Message-Id: <1173767855.10618.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 00:56 +0100, Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 10:18:03AM +1100, Rusty Russell wrote:
> > OK, this confused me:
> > 
> >         Function reordering (REORDER) [N/y/?] (NEW) ?
> >         
> >         This option enables the toolchain to reorder functions for a more 
> >         optimal TLB usage. If you have pretty much any version of binutils, 
> >         this can increase your kernel build time by roughly one minute.
> >         
> > "If you have pretty much any version of binutils"?  Huh?
> > 
> > You mean "This will slow your kernel build by about a minute"?
> 
> Yes. Lots of sections seem to trigger some quadratic behaviour in ld.
> 
> It might be fixed in some unreleased CVS version though (not 100% sure) 
> 
> -Andi

OK, well here is a patch for the moment.

==
Clarify CONFIG_REORDER explanation

if (1 && X) => if (X).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r de5618b5e562 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig	Tue Mar 13 11:41:55 2007 +1100
+++ b/arch/x86_64/Kconfig	Tue Mar 13 17:27:05 2007 +1100
@@ -632,8 +632,8 @@ config REORDER
 	default n
 	help
          This option enables the toolchain to reorder functions for a more 
-         optimal TLB usage. If you have pretty much any version of binutils, 
-	 this can increase your kernel build time by roughly one minute.
+         optimal TLB usage.  This will slow your kernel build by
+	 roughly one minute.
 
 config K8_NB
 	def_bool y


