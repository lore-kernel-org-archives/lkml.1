Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYF3PAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYF3PAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYF3PAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:00:34 -0400
Received: from smtp2.riverbed.com ([206.169.144.7]:34914 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYF3PAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:00:33 -0400
Date: Mon, 30 Jun 2008 08:01:11 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
Message-ID: <20080630150111.GE10571@ajones-laptop.nbttech.com>
References: <48652da5.s2xXeJUyQ6DrqarN%dougthompson@xmission.com> <87r6aip2pi.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87r6aip2pi.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi, ...

On Fri, Jun 27, 2008 at 10:07:21PM -0700, Andi Kleen wrote:
> dougthompson@xmission.com writes:
> >
> > 2)  I have not yet tackled the de-interleaving of the
> > rank/controller address space into the physical address
> > space of the CPU.  There is nothing fundamentally missing,
> > it is just ending up to be a lot of code, and I'd rather
> > keep it separate for now, esp since it doesn't work yet...
> >
> > 3)  The code depends on a particular i5100 chip select
> > to DIMM mainboard chip select mapping.  This mapping
> > seems obvious to me in order to support dual and single
> > ranked memory, but it is not unique and DIMM labels
> > could be wrong on other mainboards.  There is no way
> > to query this mapping that I know of.
> 
> Since there's a non negligible probability that the output
> of this driver is completely misleading because of (2) and (3)
> and probably (4) too [reporting the wrong DIMMs etc.]
> would it be possible to add some flag to EDAC that
> warns the user that the output is not fully reliable?

The code properly presents all the right info
in 2).  All that is missing the actual memory
address -- which is not printed, but everything
that it does print comes straight from the chip,
so it should be right.  Also, for 4), the driver
won't load unless it's in the proper mode.

So, that leaves 3), which is indeed highly suspect.
Most (all?) EDAC drivers don't print a DIMM label
probably for this very reason.  Perhaps it is better
to just take out that bit of code and leave the DIMM
label blank?

> -Andi (who can just see people replacing the wrong DIMMs and
> then blaming Linux)

Yeah, I can see this happening...

Arthur

> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> _______________________________________________
> bluesmoke-devel mailing list
> bluesmoke-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/bluesmoke-devel
