Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbYCDPPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbYCDPPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYCDPOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:14:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:64572 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbYCDPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qin/+eahXRvah4uGvFs1bFGnGcr1Fi7ZORtWo2rh+JGwFv5boQ2EE1YoEHQzBHkeypgTUbiF7EMkuFDNYIMj9UVohzG5nAdEiZxyLOIx5um+yUm0g9euBsQw2A0g9kk9a06jtWeCRG3ETDwnt00oPCCXWtgQ631mVSBO5b2b9O8=
Date: Tue, 4 Mar 2008 17:11:39 +0200
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, akpm <akpm@linux-foundation.org>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080304151139.GA29618@ubuntu>
References: <20080224155515.GA24831@ubuntu> <200803042355.10960.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803042355.10960.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:55:10PM +1100, Rusty Russell wrote:
> On Monday 25 February 2008 02:55:15 Ahmed S. Darwish wrote:
> > Hi all,
> >
> > Beginning from commits close to v2.6.25-rc2, running lguest always oopses
> > the host kernel. Oops is at [1].
> 
> OK, whatever the guest does should not break the host.  So your patch can't be
> the whole solution.
> 
> > static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
> > {
> > 	*pmdp = pmdval;
> > 	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
> > 		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
> > }
> >
> > The first hcall parameter is global pgdir which looks fine. The second
> > parameter is the pmd index in the pgdir which is suspectful.
> >
> > AFAIK, calculating the index of pmd does not need a divisoin over four.
> > Removing the division made lguest work fine again . Patch is at [2].
> 
> Each pmd is 4 bytes long, so the divide by 4 gives the index into the (top
> level) page. ie. a number in the range 0 to 1023.
> 

aha, now it's clear. 

>
> Indeed, here's the correct fix.  Does it work for you?
> 

Yes it does (after removing the unrelated TSC-if-pentium+ checks). 

Thank you

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

