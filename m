Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYH0GBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYH0GBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYH0GBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:01:43 -0400
Received: from homer.mvista.com ([63.81.120.158]:11019 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYH0GBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:01:42 -0400
From: "Tim Anderson" <tanderson@mvista.com>
To: <Bruce_Leonard@selinc.com>, "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-mtd-bounces@lists.infradead.org>, <linux-mtd@lists.infradead.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       <linux-kernel@vger.kernel.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Date: Tue, 26 Aug 2008 23:01:08 -0700
Message-ID: <000101c9080a$4ec3a6b0$6b01a8c0@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <OF7C027ED9.D9F1F324-ON882574B2.0007025B-882574B2.000767B6@selinc.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Thread-Index: AckH5LnscbnNCegpQnKz1lSCZK3ueAAI3iUg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce,

I have been experimenting with this. I think there is at least 3 maybe 4
IOCTLS that are going to need to have a LARGE mode. The 2 most obvious are
MEMGETINFO and MEMERASE. I was starting to code something up that passes the
size as blocks as opposed to bytes. That may be more consistent with UBI. I am
doing a little experimenting if you want some help there. In any case, it can
be done where the old utility can work (for 2GB and less size devices) and a
new call not supported by the kernel will let the utility try the new
interface and revert to the old if the kernel does not support block mode
interfaces.

Then we can either re-use the existing structures passed through another
ioctl, changing the definition of START and SIZE to be blocks or define new
erase_info_user and mtd_info_user structures for the large call.

David, would you thing re-using the same structure would be to obscure?

I have started looking at a MEMGETLINFO defining size as blocks instead of
bytes.


> -----Original Message-----
> From: linux-mtd-bounces@lists.infradead.org 
> [mailto:linux-mtd-bounces@lists.infradead.org] On Behalf Of 
> Bruce_Leonard@selinc.com
> Sent: Tuesday, August 26, 2008 6:21 PM
> To: Andrew Morton
> Cc: linux-mtd-bounces@lists.infradead.org; 
> linux-mtd@lists.infradead.org; David Woodhouse; 
> linux-kernel@vger.kernel.org; Bruce Leonard
> Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
> 
> linux-mtd-bounces@lists.infradead.org wrote on 08/26/2008 04:55:36 PM:
> 
> > On Thu, 21 Aug 2008 19:00:55 -0700 (GMT-07:00)
> > Bruce Leonard <brucle@earthlink.net> wrote:
> > 
> > > --- a/include/mtd/mtd-abi.h
> > > +++ b/include/mtd/mtd-abi.h
> > > @@ -6,7 +6,7 @@
> > >  #define __MTD_ABI_H__
> > > 
> > >  struct erase_info_user {
> > > -   uint32_t start;
> > > +   uint64_t start;
> > >     uint32_t length;
> > >  };
> > > 
> > > @@ -50,7 +50,7 @@ struct mtd_oob_buf {
> > >  struct mtd_info_user {
> > >     uint8_t type;
> > >     uint32_t flags;
> > > -   uint32_t size;    // Total size of the MTD
> > > +   uint64_t size;    // Total size of the MTD
> > >     uint32_t erasesize;
> > >     uint32_t writesize;
> > >     uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
> > 
> > This changes the kernel<->userspace ABI and is hence a big no-no.  I
> > assume that this change will cause old userspace to 
> malfunction on new
> > kernels, and vice versa.
> > 
> 
> Well, in my posting I noted that the mtd-utils were broken 
> because of this 
> but I didn't really have any idea as to how to fix things.  I 
> can see why 
> it would be a big no-no to change this.  Do you have any 
> suggestions on 
> what I could do differently to prevent making that change?
> 
> > Supporting >2Gb MTD devices sounds useful (I'm surprised 
> that we don't
> > already do so).
> > 
> 
> There was a LOT of interest in this over the last few months 
> while I was 
> working on it, but a very suprising silence has developed 
> since I posted 
> the patches.  I guess I'm more cutting edge than I thought :).
> 
> > Please cc linux-mtd@lists.infradead.org (at least) on MTD-related
> > patches, thanks.
> 
> I started with the MTD list and then also posted to lkml when 
> I realized I 
> had forgotten to CC it.
> 
> Thanks.
> 
> Bruce
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 

