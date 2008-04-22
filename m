Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbYDVLWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbYDVLWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYDVLVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:21:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45753 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761940AbYDVLVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:21:54 -0400
Date: Tue, 22 Apr 2008 12:21:52 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add a basic debugging framework for memory initialisation
Message-ID: <20080422112151.GB30798@csn.ul.ie>
References: <20080417000624.18399.35041.sendpatchset@skynet.skynet.ie> <20080417000644.18399.66175.sendpatchset@skynet.skynet.ie> <20080421151405.GI5474@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080421151405.GI5474@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (21/04/08 17:14), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +config DEBUG_MEMORY_INIT
> > +	bool "Debug memory initialisation"
> > +	depends on DEBUG_KERNEL
> > +	help
> > +	  Enable this to turn on debug checks during memory initialisation. By
> > +	  default, sanity checks will be made on the memory model and
> > +	  information provided by the architecture. What level of checking
> > +	  made and verbosity during boot can be set with the
> > +	  mminit_debug_level= command-line option.
> > +
> > +	  If unsure, say N
> 
> should be "default y" - and perhaps only disable-able on 
> CONFIG_EMBEDDED.

Ok, that would be something like the following?

       bool "Debug memory initialisation" if DEBUG_KERNEL && EMBEDDED
       depends on DEBUG_KERNEL
       default !EMBEDDED

This will slow up boot slightly on debug kernels as the additional checks
are made. It'll remain to be seen as to whether this is a problem for people
or not. I doubt it'll be noticed.

> We generally want such bugs to pop up as soon as 
> possible, and the sanity checks should only go away if someone 
> specifically aims for lowest system footprint.
> 

Seems fair and it's the second time this has been suggested (off-list reviewer
again). The only potential gotcha is if a sanity check is introduced that is
itself broken. It should be very obvious when this type of bug occurs though.

> the default loglevel for debug printouts might deserve another debug 
> option - but the core checks should always be included, and _errors_ 
> should always be printed out.
> 

I'll replace mminit_debug_level with mminit_loglevel that determines whether
information is printed at KERN_DEBUG or not. This matches what other similar
debug-frameworks are doing. I'll make sure errors always get printed.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
