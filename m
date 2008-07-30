Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbYG3EFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYG3EFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYG3EFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:05:23 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61547 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYG3EFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:05:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUFABCFj0hMRKxB/2dsb2JhbACBW4lEpTQ
Date: Wed, 30 Jul 2008 00:05:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Module : call synchronize_sched() between module
	exit() and free.
Message-ID: <20080730040518.GA20490@Krystal>
References: <20080717155724.897537670@polymtl.ca> <200807301140.59745.rusty@rustcorp.com.au> <20080730022751.GA15866@Krystal> <200807301304.51014.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807301304.51014.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:02:30 up 55 days,  8:43,  3 users,  load average: 1.24, 1.11,
	1.03
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Wednesday 30 July 2008 12:27:51 Mathieu Desnoyers wrote:
> > > Hi Mathieu,
> > >
> > >    Yes: stop_machine is merely used to atomically check the module
> > > refcount for zero and set the state so it can't be incremented again (ie.
> > > try_module_get will fail).
> > >
> > >    So placing a tracepoint or marker in a module does not bump the module
> > > refcount?  If that's true, then there needs to be some kind of
> > > remove_markers_from_module() call after module->exit(), which should do
> > > the synchronize_sched() or whatever, right?
> > >
> > > Rusty.
> >
> > Actually, it's not placing a marker/tracepoint in a module which causes
> > a problem, this is a simple function call after all, and correctly dealt
> > with by current module.c code.
> >
> > The problem comes from a probe function (the callback) that would be
> > registered to be called from a marker and would sit in an unloadable
> > kernel module. I would not want to tie the refcount of the probe modules
> > to the fact that they are connected to a marker because it would then
> > become impossible to unload them due to the fact that unregistration is
> > done in module exit().
> 
> Hi Mathieu,
> 
>     Still confused, sorry.  Why don't you don't do a synchronize_sched() at 
> the end of your module's exit routine?  "You must be completely finished by 
> the time ->exit() returns" is the rule so far...
> 

Hi Rusty,

Yes, this is I think the right solution. Sorry for the title of the
previous email : I started writing a patch and changed my mind half-way.
Doing a synchronize_sched() at the end of the exit() function seems like
the right thing to do. I'll have to update the documentation and
examples accordingly.

Thanks,

Mathieu

> Rusty.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
