Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYH0Cr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYH0Cr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYH0Crr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:47:47 -0400
Received: from tesla.selinc.com ([12.110.71.2]:39951 "EHLO tesla.selinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYH0Crq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:47:46 -0400
In-Reply-To: <008601c907e5$e1bac9f0$9101320a@mvista.com>
To: "Tim Anderson" <tanderson@mvista.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>,
       "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-mtd-bounces@lists.infradead.org
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFE4D29536.8C5F26EB-ON882574B2.000EC79F-882574B2.000ED0B4@selinc.com>
From: Bruce_Leonard@selinc.com
Date: Tue, 26 Aug 2008 19:42:00 -0700
X-MIMETrack: Serialize by Router on Edison2/SEL(Release 7.0.3|September 26, 2007) at 08/26/2008
 07:42:01 PM,
	Serialize complete at 08/26/2008 07:42:01 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's something I hadn't thought of.  Thanks, I'll look into doing 
it that way.


"Tim Anderson" <tanderson@mvista.com> wrote on 08/26/2008 06:40:26 PM:

> Bruce,
> 
> Since you don't want to change the ABI you need to extend it. Andrew, 
should
> he add an new ioctl that passes a new structure definition? That way the
> original code works and you have to do a new ioctl to get the new size 
data.
> 
> > -----Original Message-----
> > From: linux-mtd-bounces@lists.infradead.org 
> > [mailto:linux-mtd-bounces@lists.infradead.org] On Behalf Of 
> > Bruce_Leonard@selinc.com
> > Sent: Tuesday, August 26, 2008 6:21 PM
> > To: Andrew Morton
> > Cc: linux-mtd-bounces@lists.infradead.org; 
> > linux-mtd@lists.infradead.org; David Woodhouse; 
> > linux-kernel@vger.kernel.org; Bruce Leonard
> > Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
> > 
> > linux-mtd-bounces@lists.infradead.org wrote on 08/26/2008 04:55:36 PM:
> > 
> > > On Thu, 21 Aug 2008 19:00:55 -0700 (GMT-07:00)
> > > Bruce Leonard <brucle@earthlink.net> wrote:
> > > 
> > > > --- a/include/mtd/mtd-abi.h
> > > > +++ b/include/mtd/mtd-abi.h
> > > > @@ -6,7 +6,7 @@
> > > >  #define __MTD_ABI_H__
> > > > 
> > > >  struct erase_info_user {
> > > > -   uint32_t start;
> > > > +   uint64_t start;
> > > >     uint32_t length;
> > > >  };
> > > > 
> > > > @@ -50,7 +50,7 @@ struct mtd_oob_buf {
> > > >  struct mtd_info_user {
> > > >     uint8_t type;
> > > >     uint32_t flags;
> > > > -   uint32_t size;    // Total size of the MTD
> > > > +   uint64_t size;    // Total size of the MTD
> > > >     uint32_t erasesize;
> > > >     uint32_t writesize;
> > > >     uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
> > > 
> > > This changes the kernel<->userspace ABI and is hence a big no-no.  I
> > > assume that this change will cause old userspace to 
> > malfunction on new
> > > kernels, and vice versa.
> > > 
> > 
> > Well, in my posting I noted that the mtd-utils were broken 
> > because of this 
> > but I didn't really have any idea as to how to fix things.  I 
> > can see why 
> > it would be a big no-no to change this.  Do you have any 
> > suggestions on 
> > what I could do differently to prevent making that change?
> > 
> > > Supporting >2Gb MTD devices sounds useful (I'm surprised 
> > that we don't
> > > already do so).
> > > 
> > 
> > There was a LOT of interest in this over the last few months 
> > while I was 
> > working on it, but a very suprising silence has developed 
> > since I posted 
> > the patches.  I guess I'm more cutting edge than I thought :).
> > 
> > > Please cc linux-mtd@lists.infradead.org (at least) on MTD-related
> > > patches, thanks.
> > 
> > I started with the MTD list and then also posted to lkml when 
> > I realized I 
> > had forgotten to CC it.
> > 
> > Thanks.
> > 
> > Bruce
> > 
> > ______________________________________________________
> > Linux MTD discussion mailing list
> > http://lists.infradead.org/mailman/listinfo/linux-mtd/
> > 
> 

