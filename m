Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYG1Tci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYG1Tci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYG1Tcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:32:31 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:35052 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYG1Tca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:32:30 -0400
Date: Mon, 28 Jul 2008 21:32:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH] xen: xen: compile irq functions without -pg for ftrace
Message-ID: <20080728193235.GB11431@uranus.ravnborg.org>
References: <488E15C5.3070902@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E15C5.3070902@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:53:57AM -0700, Jeremy Fitzhardinge wrote:
> For some reason I managed to miss a bunch of irq-related functions
> which also need to be compiled without -pg when using ftrace.  This
> patch moves them into their own file, and starts a cleanup process
> I've been meaning to do anyway.
> 
> [ Sam, Ingo: I think the problem was that I enabled CONFIG_FTRACE
>  but didn't do a clean build.  Shouldn't the build-system notice
>  that the config changes the CFLAGS and rebuild everything?  That
>  didn't seem to happen in this case. ]

The build system usually does this.
And I have no reports that this has regressed until now.
What file?
Can you tell me how to reproduce it?

> 
> ===================================================================
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -2,9 +2,10 @@
> # Do not profile debug and lowlevel utilities
> CFLAGS_REMOVE_spinlock.o = -pg
> CFLAGS_REMOVE_time.o = -pg
> +CFLAGS_REMOVE_irq.o = -pg
> endif

I already NACK'ed this syntax and described the way it should be done.
Is this ignored or on a TODO list?

	Sam
