Return-Path: <linux-kernel-owner+w=401wt.eu-S935269AbXJTAOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269AbXJTAOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXJTAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:13:59 -0400
Received: from fw01.cmbrmaks.akamai.com ([80.67.64.10]:48948 "EHLO
	smtp2.akamai.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173AbXJTAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:13:58 -0400
Date: Fri, 19 Oct 2007 17:13:52 -0700
From: Jason Uhlenkott <juhlenko@akamai.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers-edac-i3000 replace macros with functions
Message-ID: <20071020001352.GA485@48M1231.sanmateo.corp.akamai.com>
References: <471902ff.FaxIbGYEsl+dBZCd%dougthompson@xmission.com> <20071019141118.91846dee.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019141118.91846dee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 14:11:18 -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2007 13:18:23 -0600
> dougthompson@xmission.com wrote:
> 
> > +static inline unsigned long deap_pfn(u8 edeap, u32 deap)
> > +{
> > +	deap >>= PAGE_SHIFT;
> > +	deap |= (edeap & 1) << (32 - PAGE_SHIFT);
> > +	return deap;
> > +}
> > +
> > +static inline unsigned long deap_offset(u32 deap)
> > +{
> > +	return deap & ~(I3000_DEAP_GRAIN - 1) & ~PAGE_MASK;
> > +}
> > +
> 
> The types here look a bit confused.  Implicit conversions of
> u32s into unsigned longs.

That's deliberate, though perhaps not as clear as it could have been:
We're calculating a pfn and an offset which are logically unsigned
longs (and treated as such by the higher level edac code where they
ultimately get passed) from some bits in config space registers which
are u8/u32.
