Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbYDVP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbYDVP0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYDVP0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:26:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18612 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760519AbYDVP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:26:05 -0400
Date: Tue, 22 Apr 2008 08:25:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, jason.wessel@windriver.com,
       linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
Message-Id: <20080422082519.62adc7f1.randy.dunlap@oracle.com>
In-Reply-To: <20080421214636.617970c6.akpm@linux-foundation.org>
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
	<20080418150930.476ea7aa.akpm@linux-foundation.org>
	<20080421141252.GR9554@elte.hu>
	<20080421214636.617970c6.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 21:46:36 -0700 Andrew Morton wrote:

> > On Mon, 21 Apr 2008 16:12:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > So please
> > > 
> > > a) make this a kerneldoc comment and
> > > 
> > > b) remove the kerneldoc at the definition site(s).
> > > 
> > > (alternative: teach the kerneldoc system to go fishing in the various 
> > > arch directories to find the appropriate documentation, but I don't 
> > > know enough about kerneldoc to be able say anything about that).
> > 
> > well there's lkml feedback ping-pong effect here. It was pointed out in 
> > earlier kgdb review that it's an "error" to put kerneldoc into header 
> > files.

As Andrew has pointed out in various emails, it is convention to
put kernel-doc near definitions (implementations), not near
declarations (headers).  [Boy, I hope I didn't get those reversed.]
But it's just convention for the sake of consistency AFAIK.
kernel-doc will read header files if that's what we tell it to do.

> It is, normally.  Nobody thought about this case.
> 
> > I pointed out that it makes no sense to do otherwise but removed 
> > the kerneldoc annotation to resolve the "objection".
> 
> Duplicating the same stuff in multiple places is the larger sin.  It sounds
> like the best compromise would be to kernel-doc the interface in the .h
> file and remove the duplicated comments from .c.

Yes, duplication would be Bad.

> Or perhaps we kernel-doc the interface in the x86 .c files and leave it at
> that - people should go there to find the docs.  Problem is, this will

That's (using x86) fairly common also, esp. for functions that header
files (inline functions and macros).

> presumably generate bad results if one builds the formal kerneldoc output
> for a different architecture.  The kerneldoc system could of course fix
> this somehow, but I don't know what shape it would take nor how much work
> it would be.

kernel-doc output doesn't depend on build $ARCH.


---
~Randy
