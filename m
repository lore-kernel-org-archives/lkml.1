Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZALTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZALTyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZALTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:54:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:21834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbZALTyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:54:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,254,1231142400"; 
   d="scan'208";a="99138996"
Date: Mon, 12 Jan 2009 11:54:38 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112195438.GA4538@linux-os.sc.intel.com>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:47:13AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 12 Jan 2009, Pallipadi, Venkatesh wrote:
> > +		if (strict_prot ||
> > +		    (want_flags == _PAGE_CACHE_UC_MINUS &&
> > +		     flags == _PAGE_CACHE_WB) ||
> > +		    (want_flags == _PAGE_CACHE_WC &&
> > +		     flags == _PAGE_CACHE_WB)) {
> 
> Please don't write code like this.
> 
> Do it as an inline function that returns true/false and has comments on 
> what the hell is going on.
> 
> If a conditional doesn't fit on one line, it should generally be 
> abstracted away into a readable function where the name explains what it 
> does conceptually.
> 

Yes. The actual patch that is lined up in tip fixes indeed has this as a
macro sharing this code with 2 callers and comment about this
(is_new_memtype_allowed()). I wanted to keep the changes smaller in this
test patch, which is just to root cause this particular crash and ended
up with above code.

Thanks,
Venki
