Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYE0Jru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYE0Jru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYE0Jrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:47:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:49580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754634AbYE0Jrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:47:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Me2QSFrjM/37Juik2SeV0aYZdY9BF9aaAbfU/ow
	NTjPwT+MHjx9ng
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
From: Mike Galbraith <efault@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080527085830.GA20938@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 27 May 2008 11:47:38 +0200
Message-Id: <1211881658.6742.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 11:58 +0300, Adrian Bunk wrote:

> Once it is feature complete and then got the usual testing through
> -next I'll have no objections against offering it again to users.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> c67cfbbb40895b72760865527dd1949631b1d183 diff --git a/init/Kconfig b/init/Kconfig
> index d9526b5..564deba 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -333,7 +333,7 @@ config HAVE_UNSTABLE_SCHED_CLOCK
>  
>  config GROUP_SCHED
>  	bool "Group CPU scheduler"
> -	depends on EXPERIMENTAL
> +	depends on BROKEN
>  	default n
>  	help
>  	  This feature lets CPU scheduler recognize task groups and control CPU

FWIW, here's my NAK, and the grounds therefore:  Group scheduling
clearly fits the current criteria for CONFIG_EXPERIMENTAL.  In-tree
development is a necessary fact of life, and has always been a fact of
life.  IMO, your attempt to change the rules is seriously misguided.

<quote>
config EXPERIMENTAL
	bool "Prompt for non-development and/or absolutely complete code/drivers"
	---help---
	  Some of the various things that Linux supports (such as network
	  drivers, file systems, network protocols, etc.) can be in a state
	  of development where the functionality, stability, or the level of
	  testing is not yet high enough for general use. This is usually
	  known as the "alpha-test" phase among developers. If a feature is
	  currently in alpha-test, then the developers usually discourage
	  uninformed widespread use of this feature by the general public to
	  avoid "Why doesn't this work?" type mail messages. However, active
	  testing and use of these systems is welcomed. Just be aware that it
	  may not meet the normal level of reliability or it may fail to work
	  in some special cases. Detailed bug reports from people familiar
	  with the kernel internals are usually welcomed by the developers
	  (before submitting bug reports, please read the documents
	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
	  <file:Documentation/BUG-HUNTING>, and
	  <file:Documentation/oops-tracing.txt> in the kernel source).

	  This option will also make obsoleted drivers available. These are
	  drivers that have been replaced by something else, and/or are
	  scheduled to be removed in a future kernel release.

	  Unless you intend to help test and develop a feature or driver that
	  falls into this category, or you have a situation that requires
	  using these features, you should probably say N here, which will
	  cause the configurator to present you with fewer choices. If
	  you say Y here, you will be offered the choice of using features or
	  drivers that are currently considered to be in the alpha-test phase.
</quote>

	-Mike

