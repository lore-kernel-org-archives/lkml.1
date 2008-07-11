Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbYGKUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbYGKUQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYGKUQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:16:14 -0400
Received: from [194.117.236.238] ([194.117.236.238]:37711 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYGKUQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:16:14 -0400
Date: Fri, 11 Jul 2008 23:14:52 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH 5/5] kmemtrace: SLOB hooks.
Message-ID: <20080711231452.4ea5d7e4@linux360.ro>
In-Reply-To: <1215790597.4800.2.camel@calx>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-5-git-send-email-eduard.munteanu@linux360.ro>
	<20080710210623.1cad3c3c@linux360.ro>
	<84144f020807110144t359ef9d3q36a0ca7caa36841f@mail.gmail.com>
	<1215790597.4800.2.camel@calx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 10:36:37 -0500
Matt Mackall <mpm@selenic.com> wrote:

> 
> On Fri, 2008-07-11 at 11:44 +0300, Pekka Enberg wrote:
> > Hi,
> > 
> > Matt, can you take a look at this? I know you don't want *debugging*
> > code in SLOB but this is for instrumentation.
> 
> I presume this code all disappears in a default SLOB build?

Yes, of course. If CONFIG_KMEMTRACE is disabled, those calls go into
empty static inlines.
 
> > On Thu, Jul 10, 2008 at 9:06 PM, Eduard - Gabriel Munteanu
> > <eduard.munteanu@linux360.ro> wrote:
> > > This adds hooks for the SLOB allocator, to allow tracing with
> > > kmemtrace.
> > >
> > > Signed-off-by: Eduard - Gabriel Munteanu
> > > <eduard.munteanu@linux360.ro> ---
> > >  mm/slob.c |   37 +++++++++++++++++++++++++++++++------
> > >  1 files changed, 31 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/mm/slob.c b/mm/slob.c
> > > index a3ad667..44f395a 100644
> > > --- a/mm/slob.c
> > > +++ b/mm/slob.c
> > > @@ -65,6 +65,7 @@
> > >  #include <linux/module.h>
> > >  #include <linux/rcupdate.h>
> > >  #include <linux/list.h>
> > > +#include <linux/kmemtrace.h>
> > >  #include <asm/atomic.h>
> > >
> > >  /*
> > > @@ -463,27 +464,38 @@ void *__kmalloc_node(size_t size, gfp_t
> > > gfp, int node) {
> > >        unsigned int *m;
> > >        int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> > > +       void *ret;
> 
> There's tons of tab damage in this patch. Or perhaps it's just been
> mangled by someone's mailer?

I know :-(. This was intended as a simple RFC, things will change on
subsequent submissions.
