Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbXEWQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbXEWQRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934155AbXEWQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:17:05 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:36778 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933827AbXEWQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:17:03 -0400
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705231153360.7749@localhost.localdomain>
References: <20070521151525.GA581@suse.de>
	 <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
	 <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
	 <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705231153360.7749@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 23 May 2007 11:17:01 -0500
Message-Id: <1179937021.3700.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 11:55 -0400, Robert P. J. Day wrote:
> On Wed, 23 May 2007, James Bottomley wrote:
> 
> > I'll defer to Mark on this one.  However, please remember that you
> > can't just blindly remove GFP_DMA ... there are some cards which
> > require it.
> >
> > Aacraid is one example ... it has a set of cards that can only DMA
> > to 31 bits.  For them, the GFP_DMA is necessary:  The allocation in
> > question is a scatterlist, which must be within the device DMA mask.
> 
> a question i asked a while back, and still haven't seen an answer for
> -- given this in include/linux/gfp.h:
> 
>   #define GFP_DMA         __GFP_DMA
> 
> is there a qualitative difference between these two macros?  is there
> *supposed* to be?  if there isn't, one would think that just one
> variation would be sufficient.

__GFP_ are the raw GFP flags ... the GFP_ are combinations of the flags
with predefined meanings.  There's no convention that you have to use
one form or the other when making combinations of the allocation flags.
Historically that's lead to things like

GFP_ATOMIC | __GFP_DMA (indicating additional DMA zone to the usual
atomic flags)

and

GFP_ATOMIC | GFP_DMA (indicating same thing, but with the defined flags)

You can argue that GFP_DMA has a pretty bogus GFP meaning and should
never appear on its own, which, to my mind makes the former usage
preferable.  However, GFP_DMA has been in linux since pretty much the
dawn of ISA drivers, so I think it's conventionally well understood.

James


James


