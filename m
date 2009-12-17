Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZLQFPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZLQFPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZLQFPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:15:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60430 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZLQFPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:15:50 -0500
Date: Thu, 17 Dec 2009 14:15:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5/5] sh: dmaengine support for sh7724
Message-ID: <20091217051543.GB3946@linux-sh.org>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange> <Pine.LNX.4.64.0912041942330.3981@axis700.grange> <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com> <20091208071302.GA23814@linux-sh.org> <29ab51dc0912161914w6967c9d1l79df27d670f01b6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29ab51dc0912161914w6967c9d1l79df27d670f01b6a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:14:14PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> 2009/12/8 Paul Mundt <lethal@linux-sh.org>:
> > On Mon, Dec 07, 2009 at 06:02:24PM -0700, Dan Williams wrote:
> >> On Fri, Dec 4, 2009 at 11:45 AM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > Add a dmaengine platform device to sh7724, fix DMA channel interrupt numbers.
> >> >
> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> > ---
> >> >
> >> > With this patch dmatest works with channels 0-5, channels 6-11 still don't
> >> > work for some reason... So, feel free to discard it for now, if a complete
> >> > fix would be preferred.
> >>
> >> Does this patch limit operation to channels 0-5? ?I leave this one for
> >> Paul to disposition.
> >>
> > There are 6 channels per controller, so the fact that the second
> > controller isn't working could either be cause the driver needs more work
> > to handle multiple controllers properly, or there could be a pinmux issue
> > that hasn't been resolved yet for DMAC1. Both of these cases require the
> > driver to be a bit smarter, but as Guennadi is presently working on these
> > things, doing them incrementally is ok with me. If this gets DMAC0
> > working at least where it wasn't before, it's certainly worth applying.
> > DMAC1 seems to have more problems than just wrong interrupt numbers, so
> > this isn't going to cause any regressions there either.
> >
> > Acked-by: Paul Mundt <lethal@linux-sh.org>
> 
> This patch can not apply Paul's git/HEAD too.
> I updated patch.
> 
> Acked-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> 

Ok, this doesn't really have any outstanding build dependencies, but
obviously isn't going to pass the test cases until the outstanding
dmaengine patches are merged.

In any event, fixing up the wrong IRQs is something we should be doing
sooner rather than later, so I'll queue this up as it is. Hopefully the
dmaengine bits will be sorted in time for -rc2 and then everything should
just magically work ;-)
