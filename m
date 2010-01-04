Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651Ab0ADRYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0ADRYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0ADRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:24:05 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40600 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0ADRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:23:58 -0500
Date: Mon, 4 Jan 2010 11:22:48 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to
 dynamically allocate counters
In-Reply-To: <4B317B5E.1010500@kernel.org>
Message-ID: <alpine.DEB.2.00.1001041121570.7191@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org> <alpine.DEB.2.00.0912220956340.12163@router.home> <4B317B5E.1010500@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009, Tejun Heo wrote:

> On 12/23/2009 12:57 AM, Christoph Lameter wrote:
> > On Mon, 21 Dec 2009, Tejun Heo wrote:
> >
> >>
> >>> Index: linux-2.6/kernel/trace/ring_buffer.c
> >>> ===================================================================
> >>> --- linux-2.6.orig/kernel/trace/ring_buffer.c	2009-12-18 13:13:24.000000000 -0600
> >>> +++ linux-2.6/kernel/trace/ring_buffer.c	2009-12-18 14:15:57.000000000 -0600
> >>> @@ -12,6 +12,7 @@
> >>>  #include <linux/hardirq.h>
> >>>  #include <linux/kmemcheck.h>
> >>>  #include <linux/module.h>
> >>> +#include <asm/local.h>
> >>
> >> This doesn't belong to this patch, right?  I stripped this part out,
> >> added Cc: to Rusty and applied 1, 2, 7 and 8 to percpu branch.  I'll
> >> post the updated patch here. Thanks.
> >
> > If you strip this part out then ringbuffer.c will no longer compile
> > since it relies on the "#include <local.h>" that is removed by this patch
> > from the module.h file.
>
> Oh... alright.  I'll add that comment and drop the offending chunk and
> recommit.

So we need a separate patch to deal with remval of the #include
<asm/local.h> from modules.h?

