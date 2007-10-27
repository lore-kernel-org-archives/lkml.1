Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbXJ0AU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbXJ0AU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXJ0AUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:20:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXJ0AUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:20:09 -0400
Date: Fri, 26 Oct 2007 17:16:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
Message-ID: <20071026171606.4e242f49@laptopd505.fenrus.org>
In-Reply-To: <47228278.8070505@garzik.org>
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075808.GH6407@havoc.gtf.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
	<20071026143525.b9218ed7.akpm@linux-foundation.org>
	<4722608E.3000405@garzik.org>
	<20071026165035.33383e36@laptopd505.fenrus.org>
	<47228278.8070505@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 20:12:40 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > On Fri, 26 Oct 2007 17:47:58 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> Andrew Morton wrote:
> >>> That was a goofup.  I proposed that we should add a #define
> >>> TWO_ARG_IRQ_HANDLERS (or whatever) and I think I actually wrote
> >>> the patch, but it got lost.
> >>>
> >>> I agree it would be a kind thing to do in this case.
> > 
> >>
> >> Yep, I was thinking that including
> >>
> >> 	#define IRQ_HANDLER_V3
> >>
> >> would be a good idea.
> >>
> > 
> > it sets a certain precedent though.... we don't do this for the 500
> > other API changes we do each release (see stable-api-nonsense)... so
> > this one is mostly arbitrary picked out
> 
> We do for include/linux/netdevice.h, see HAVE_xxx -- and we should do
> it because the last irq handler change was a pain for backports, and
> this makes life easier for the backporters.  irq handling is probably
> far more global than any other kernel API except kmalloc()

to be honest, in a perfect world we turn this around, and have the
older kernels that people want to backport to have the
LEGACY_IRQ_HANDLER defines... not accumulating going forward....
(in fact, with what you're proposing you'll always get #ifndef's..)

the other serious question is.. how is IRQ_HANDLER_V3 different from a
#ifdef VERSION >= 2.6.24 .....
it's not really ;)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
