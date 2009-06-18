Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZFRPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZFRPnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZFRPmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:42:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38135 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZFRPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:42:54 -0400
Date: Thu, 18 Jun 2009 16:42:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: yan.i.li@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090618154250.GA30209@srcf.ucam.org>
References: <20090615143446.GB19451@srcf.ucam.org> <20090615144748.GA25734@thyme.bj.intel.com> <20090616154200.GA12715@srcf.ucam.org> <20090616173618.353901ee@lxorguk.ukuu.org.uk> <20090616164351.GA14353@srcf.ucam.org> <20090616181549.496ae0f2@lxorguk.ukuu.org.uk> <20090616171732.GA14912@srcf.ucam.org> <20090617010138.GA13479@thyme.bj.intel.com> <20090617025101.GA27595@srcf.ucam.org> <20090618000809.GB16835@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618000809.GB16835@thyme.bj.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 08:08:09AM +0800, Li, Yan wrote:
> On Wed, Jun 17, 2009 at 03:51:01AM +0100, Matthew Garrett wrote:
> > On Wed, Jun 17, 2009 at 09:01:40AM +0800, Li, Yan I wrote:
> > > This seems a change too aggressive for me. Do we have a good reason
> > > for taking this risk? 
> > 
> > It's generally much easier to find regressions (people complain) than it 
> > is to find things that have never worked (people just assume Linux is 
> > broken).
> 
> That's true. But we are not sure how many regressions we'll meet and
> whether the efforts devoted to handle them is worthy. (How to handle
> regressions? Perhaps, ironically, we'll need another 'whitelist' for
> them!)

If we hit regressions then it's the wrong fix and would have to be 
reverted. Better a small blacklist than a large whitelist (though, in 
the general case, the presence of either is an indication of a bug)

> > > Of course if we found the "actual problem" we'd conjure up a better 
> > > fix. But before that, I'd prefer the conservative way.
> > 
> > Does stock Windows work on the machine? I think this really ought to be 
> > a pretty obvious minimal test before adding quirks to the kernel.
> 
> Does this matter?  Does whether Windows fail or not affect our
> decision here?  (Worse that I have no "stock Windows XP" for
> testing. All I have are those companion Windows Recovery CDs that
> include all drivers).

Yes. If Windows works without hardware specific drivers then there's a 
flaw in our i8042 setup code that's affecting an unknown number of 
machines, and adding more entries to a static table tells us nothing 
about what proportion of those machines are now fixed - it just tells us 
that we've worked around the issue for the ones that Intel happen to be 
testing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
