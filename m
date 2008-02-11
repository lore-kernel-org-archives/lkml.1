Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbYBKUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbYBKUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYBKUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:38:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYBKUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:37:59 -0500
Date: Mon, 11 Feb 2008 12:36:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support
 self-snoop
Message-ID: <20080211123659.421bfaee@laptopd505.fenrus.org>
In-Reply-To: <20080211194712.GA21118@linux-os.sc.intel.com>
References: <200802111050.372086035@suse.de>
	<200802111627.23751.ak@suse.de>
	<20080211173606.GB21564@linux-os.sc.intel.com>
	<200802111858.46200.ak@suse.de>
	<20080211194712.GA21118@linux-os.sc.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 11:47:12 -0800
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:

> On Mon, Feb 11, 2008 at 06:58:46PM +0100, Andi Kleen wrote:
> > On Monday 11 February 2008 18:36:06 Siddha, Suresh B wrote:
> > > On Mon, Feb 11, 2008 at 04:27:23PM +0100, Andi Kleen wrote:
> > > > 
> > > > > > That is exactly the situation in pageattr.c. You're saying
> > > > > > the manual is wrong here?
> > > > > 
> > > > > I'm saying that we are not following step 2 (marking the
> > > > > pages not present) 
> > > > 
> > > > Yes that's true. It's one of the design problems of the intent
> > > > API that makes fixing this hard unfortunately.
> > > 
> > > BTW, making pages not present is required only while changing the
> > > attribute from WB to WC or WC to WB. I think this step is for
> > > avoiding attribute aliasing for speculative accesses. For UC, we
> > > don't have speculative accesses and such we probably don't need
> > > it.
> > 
> > Ok that would imply that my patch is ok for all current in tree
> > users at least (none of them ever set WC currently, only UC). It
> > might not be safe for the out of tree WC users though.
> > 
> > So it should be ok to apply according to standard policy :)
> 
> There is atleast one issue though. For an I/O device which is not
> capable of snooping the caches, if the driver model assumes that
> ioremap_nocache() will flush the cpu caches(before initiating DMA),
> then the lack of cache flush in cpa() might cause some breakages.

this is a totally separate issue and I agree, it needs a separate API.
(well there is one more or less, but lets make it explicit).

> > > So WC support through PAT should take care of it.
> > 
> > You mean the PAT patch should do something about it? Yes probably,
> > but what?
> 
> marking the pages not present etc..

another option is to do a three-step tango; go from WB to UC, flush, then go from UC to WB.

We need to deal with this for correctness anyway (since this could happen naturally) so
might as well do things that way.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
