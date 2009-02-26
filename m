Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZBZTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZBZTWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBZTWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:22:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:34922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZBZTWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:22:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,272,1233561600"; 
   d="scan'208";a="668807231"
Subject: Re: Linux 2.6.29-rc6
From: David Woodhouse <david.woodhouse@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Krogh <jesper@krogh.cc>, Dave Olsen <dolsen@lnxi.com>,
       Ryan Jackson <rjackson@lnxi.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A679E8.1010301@krogh.cc>
	 <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
Organization: Intel Corporation
Date: Fri, 27 Feb 2009 04:22:01 +0900
Message-Id: <1235676121.8730.167.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 17:53 +0000, Linus Torvalds wrote:
> Dave Olsen <dolsen@lnxi.com>,
>     Ryan Jackson <rjackson@lnxi.com>, David.Woodhouse@intel.com, 
> linux-mtd@lists.infradead.org
> 
> 
> On Thu, 26 Feb 2009, Jesper Krogh wrote:
> >
> > 
> > Booting up 2.6.29-rc6 gave me this one in dmesg...
> > 
> > [   21.136149] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
> 
> Well, it _is_ a kernel bug, but it's in that stupid driver. It does 
> everything wrong, including printing out a scary message.
> 
> Piece of sh*t driver, in other words.
> 
> I mean, it even has a _comment_ about how the request_region is likely to 
> not succeed, and then it prints out that scary message when it 
> then doesn't do so.
> 
> Not to mention that the driver is likely _wrong_ to just unconditionally 
> try to enable that resource without *first* checking whether the resource 
> can actually be enabled or whether there are other resources in that same 
> window.
>
> Quite frankly, I find that whole thing scary. The driver should be deleted 
> or at least marked EXPERIMENTAL or BROKEN.

It's giving you access to your BIOS flash so that you can overwrite it
from within Linux. It's _supposed_ to be scary :)

It's also always going to be a hack -- it's a PITA getting direct access
to that flash on most PeeCee chipsets. The driver operates on the
principle that it knows the hardware, and it can _make_ the flash appear
at the appropriate physical addresses. The theory, at least, is that it
knows better than the kernel does.

But yeah, it should probably at least look for other things which
already overlap with the region that it's trying to 'create'. Although
the comment leads me to believe that sometimes that's _expected_ and
shouldn't cause the driver to abort.

Dave, Ryan, are you still actively using this?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

