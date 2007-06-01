Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXFAAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXFAAPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXFAAPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:15:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42983 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbXFAAPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:15:24 -0400
Date: Fri, 1 Jun 2007 02:14:53 +0200 (MEST)
Message-Id: <200706010014.l510ErWa022252@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> >  
> > > > Use the faster conditional calls for F00F bug handling in do_page_fault.
> > > > 
> > > 
> > > I guess this means that CONDCALL will be enabled on pretty much all i386,
> > > in which case making the whole feature Kconfigurable is starting to look
> > > marginal.
> > > 
> > > Perhaps a better approach would have to made this change dependent upon
> > > CONDCALL, rather than forcing it on.
> > > 
> > 
> > Do you mean making X86_F00F_BUG depend on COND_CALL instead of selecting
> > it ?
> 
> yup

X86_F00F_BUG needs to be enabled in all kernels capable of booting on
P5 class machines, whether or not some obscure CONFIG_COND_CALL thingy
is enabled or not. X86_F00F_BUG is not some optional optimisation, it's
an essential workaround for a serious hardware bug.

Therefore it seems select rather than depend is called for.
