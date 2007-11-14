Return-Path: <linux-kernel-owner+w=401wt.eu-S1763873AbXKNWrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763873AbXKNWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbXKNWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:46:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbXKNWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:46:58 -0500
Date: Wed, 14 Nov 2007 14:34:15 -0800
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stable <stable@kernel.org>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Message-ID: <20071114223415.GA771@kroah.com>
References: <20071022171426.31103.patches@notabene> <20071114002214.GA31928@kroah.com> <20071114002308.GB31928@kroah.com> <e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com> <20071114034325.GA25558@kroah.com> <e9c3a7c20711132136t6cc9a91avb1d1ddf257701331@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20711132136t6cc9a91avb1d1ddf257701331@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:36:30PM -0700, Dan Williams wrote:
> On Nov 13, 2007 8:43 PM, Greg KH <greg@kroah.com> wrote:
> > >
> > > Careful, it looks like you cherry picked commit 4ae3f847 "md: raid5:
> > > fix clearing of biofill operations" which ended up misapplied in
> > > Linus' tree,  You should either also pick up def6ae26 "md: fix
> > > misapplied patch in raid5.c" or I can resend the original "raid5: fix
> > > clearing of biofill operations."
> > >
> > > The other patch for -stable "raid5: fix unending write sequence" is
> > > currently in -mm.
> >
> > Hm, I've attached the two patches that I have right now in the -stable
> > tree so far (still have over 100 patches to go, so I might not have
> > gotten to them yet if you have sent them).  These were sent to me by
> > Andrew on their way to Linus.  if I should drop either one, or add
> > another one, please let me know.
> >
> 
> Drop md-raid5-fix-clearing-of-biofill-operations.patch and replace it
> with the attached
> md-raid5-not-raid6-fix-clearing-of-biofill-operations.patch (the
> original sent to Neil).
> 
> The critical difference is that the replacement patch touches
> handle_stripe5, not handle_stripe6.  Diffing the patches shows the
> changes for hunk #3:
> 
> -@@ -2903,6 +2907,13 @@ static void handle_stripe6(struct stripe
> +@@ -2630,6 +2634,13 @@ static void handle_stripe5(struct stripe_head *sh)

Ah, ok, thanks, will do that.

> raid5-fix-unending-write-sequence.patch is in -mm and I believe is
> waiting on an Acked-by from Neil?

I don't see it in Linus's tree yet, so I can't apply it to -stable...

thanks,

greg k-h
