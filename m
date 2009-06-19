Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZFSHRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZFSHRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFSHRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:17:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:8561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZFSHRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,250,1243839600"; 
   d="scan'208";a="423645416"
Date: Fri, 19 Jun 2009 15:16:55 +0800
From: "Li, Yan I" <yan.i.li@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>, yanli@infradead.org
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090619071634.GA7671@thyme.bj.intel.com>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"greg@kroah.com" <greg@kroah.com>, yanli@infradead.org
References: <20090615144748.GA25734@thyme.bj.intel.com>
 <20090616154200.GA12715@srcf.ucam.org>
 <20090616173618.353901ee@lxorguk.ukuu.org.uk>
 <20090616164351.GA14353@srcf.ucam.org>
 <20090616181549.496ae0f2@lxorguk.ukuu.org.uk>
 <20090616171732.GA14912@srcf.ucam.org>
 <20090617010138.GA13479@thyme.bj.intel.com>
 <20090617025101.GA27595@srcf.ucam.org>
 <20090618000809.GB16835@thyme.bj.intel.com>
 <20090618154250.GA30209@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618154250.GA30209@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 11:42:50PM +0800, Matthew Garrett wrote:
> On Thu, Jun 18, 2009 at 08:08:09AM +0800, Li, Yan wrote:
> > That's true. But we are not sure how many regressions we'll meet and
> > whether the efforts devoted to handle them is worthy. (How to handle
> > regressions? Perhaps, ironically, we'll need another 'whitelist' for
> > them!)
> 
> If we hit regressions then it's the wrong fix and would have to be 
> reverted. 

Still, I don't think we have enough reason to enable multi-reset of
i8042 for all machines: the old code (sane and following specs) has
been working well since long ago for most machines, and not until
recently we have seen special cases, no more than half a dozen
machines that needs special treating.  These few glitches can't
justify a global move.

Without a good reason, your move (try and revert if hit regressions)
seems to be the trial-and-error approach, and not very good for the
stable release (though perfectly safe for some testing branches).

>           Better a small blacklist than a large whitelist (though, in 
> the general case, the presence of either is an indication of a bug)

We have no way to know which one is smaller one, the current list is
very small (5 entries).  I'll change my mind if this
i8042_dmi_reset_table[] keeps growing.

The presence of {black,white}list (or more generally, quirks) is the
software reflection of the complexity of the world, not necessarily a
bug.  They are popular (if not ubiquitous) among the kernel.


> > Does this matter?  Does whether Windows fail or not affect our
> > decision here?  (Worse that I have no "stock Windows XP" for
> > testing. All I have are those companion Windows Recovery CDs that
> > include all drivers).
> 
> Yes. If Windows works without hardware specific drivers then there's a 
> flaw in our i8042 setup code that's affecting an unknown number of 
> machines, and adding more entries to a static table tells us nothing 
> about what proportion of those machines are now fixed - it just tells us 
> that we've worked around the issue for the ones that Intel happen to be 
> testing.

Not necessarily if we had followed the spec (I'm not sure of this) of
using i8042.

Hope someone can help us do this test.  I have already found loads of
touchpad drivers on net so I guess Windows can't drive a touchpad
until a driver is installed.  Pure guess.

-- 
Best regards,
Li, Yan

Moblin Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
