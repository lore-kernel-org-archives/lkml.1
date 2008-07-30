Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYG3DFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYG3DFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 23:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYG3DEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 23:04:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYG3DEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 23:04:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Module : call synchronize_sched() between module exit() and free.
Date: Wed, 30 Jul 2008 13:04:50 +1000
User-Agent: KMail/1.9.9
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20080717155724.897537670@polymtl.ca> <200807301140.59745.rusty@rustcorp.com.au> <20080730022751.GA15866@Krystal>
In-Reply-To: <20080730022751.GA15866@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301304.51014.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 12:27:51 Mathieu Desnoyers wrote:
> > Hi Mathieu,
> >
> >    Yes: stop_machine is merely used to atomically check the module
> > refcount for zero and set the state so it can't be incremented again (ie.
> > try_module_get will fail).
> >
> >    So placing a tracepoint or marker in a module does not bump the module
> > refcount?  If that's true, then there needs to be some kind of
> > remove_markers_from_module() call after module->exit(), which should do
> > the synchronize_sched() or whatever, right?
> >
> > Rusty.
>
> Actually, it's not placing a marker/tracepoint in a module which causes
> a problem, this is a simple function call after all, and correctly dealt
> with by current module.c code.
>
> The problem comes from a probe function (the callback) that would be
> registered to be called from a marker and would sit in an unloadable
> kernel module. I would not want to tie the refcount of the probe modules
> to the fact that they are connected to a marker because it would then
> become impossible to unload them due to the fact that unregistration is
> done in module exit().

Hi Mathieu,

    Still confused, sorry.  Why don't you don't do a synchronize_sched() at 
the end of your module's exit routine?  "You must be completely finished by 
the time ->exit() returns" is the rule so far...

Rusty.
