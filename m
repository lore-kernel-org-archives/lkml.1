Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbXFAAoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbXFAAoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbXFAAoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:44:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339AbXFAAoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:44:12 -0400
Date: Thu, 31 May 2007 17:43:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Message-Id: <20070531174355.544e7588.akpm@linux-foundation.org>
In-Reply-To: <200706010014.l510ErWa022252@harpo.it.uu.se>
References: <200706010014.l510ErWa022252@harpo.it.uu.se>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 02:14:53 +0200 (MEST)
Mikael Pettersson <mikpe@it.uu.se> wrote:

> Andrew Morton wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > >  
> > > > > Use the faster conditional calls for F00F bug handling in do_page_fault.
> > > > > 
> > > > 
> > > > I guess this means that CONDCALL will be enabled on pretty much all i386,
> > > > in which case making the whole feature Kconfigurable is starting to look
> > > > marginal.
> > > > 
> > > > Perhaps a better approach would have to made this change dependent upon
> > > > CONDCALL, rather than forcing it on.
> > > > 
> > > 
> > > Do you mean making X86_F00F_BUG depend on COND_CALL instead of selecting
> > > it ?
> > 
> > yup
> 
> X86_F00F_BUG needs to be enabled in all kernels capable of booting on
> P5 class machines, whether or not some obscure CONFIG_COND_CALL thingy
> is enabled or not. X86_F00F_BUG is not some optional optimisation, it's
> an essential workaround for a serious hardware bug.
> 
> Therefore it seems select rather than depend is called for.

Nope.

CONFIG_COND_CALL=n	-> 	do f00f handling the present way
CONFIG_COND_CALL=y	-> 	do f00f handling the new, fast-n-fancy way


Because I don't think everyone will want to drag all this cond_call stuff
into their kernel just for slightly faster f00f handling.

