Return-Path: <linux-kernel-owner+w=401wt.eu-S1767570AbXECRva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767570AbXECRva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767568AbXECRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:51:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37137 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767569AbXECRv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:51:26 -0400
Date: Thu, 3 May 2007 19:51:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070503175125.GL3531@stusta.de>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <1178084403.28659.222.camel@localhost.localdomain> <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com> <1178087393.28659.238.camel@localhost.localdomain> <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com> <1178089444.28659.246.camel@localhost.localdomain> <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com> <20070502145550.GE3531@stusta.de> <20070502150546.GF3531@stusta.de> <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 10:16:15AM -0700, David Rientjes wrote:
> On Wed, 2 May 2007, Adrian Bunk wrote:
> 
> > If we don't want any warnings with CONFIG_PCI=n, CONFIG_SYSFS=n or
> > CONFIG_PROC_FS=n, we'd have to annotate _many_ functions.
> > 
> > If the lonterm goal is to compile the kernel with -Werror then we need 
> > -Wno-unused-function, not annotating individual functions.
> 
> That's only addressing part of the issue.  What about automatic or static 
> external variables that are declared but may go unreferenced depending on 

This is only about static code. For non-static code it would be
impossible for gcc to issue warnings.

> preprocessor macros?  You need to annotate them with __attribute__ 
> ((unused)) to suppress compiler warnings.  Globally disabling such 
> warnings would eventually cause unused code to go unnoticed.

But looking at a kernel build it seems there are far few warnings than I 
remembered, so it might actually be possible to annotate all code 
accordingly.

> 		David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

