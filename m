Return-Path: <linux-kernel-owner+w=401wt.eu-S2993173AbXEBWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993173AbXEBWKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993188AbXEBWKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:10:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45095 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993173AbXEBWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:10:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46390C3F.9060905@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 00:10:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <4639085A.8010504@s5r6.in-berlin.de>
In-Reply-To: <4639085A.8010504@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Christoph Hellwig wrote:
>>> +	/* Convert the scatterlist to an sbp2 page table.  If any
>>> +	 * scatterlist entries are too big for sbp2 we split the as we go. */
>> Please set the max_sectors value in your host template so that the
>> block layer doesn't build sg entries too big for you.
> 
> Hmm, what about this:
> 
> James Bottomley wrote on 2007-01-15:
> | Actually, there's one unfortunate case where Linux won't respect this:
> | an IOMMU that can do virtual merging.  This parameter is a block queue
> | parameter, so block will happily make sure the request segments obey it.
> | However, when you get to dma_map_rq() it doesn't see the segment limits,
> | so, if the iommu merges, you can end up with SG elements the other side
> | that violate this.  I've been meaning to do something about this for
> | ages (IDE is the other subsystem that has an absolute requirement for a
> | fixed maximum segment size) but never found an excuse to fix it.
> 
> http://marc.info/?l=linux-scsi&m=116889641203397

PS:
Nonetheless, yes, fw-sbp2.c is curiously missing to set the template's
max_sectors.
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
