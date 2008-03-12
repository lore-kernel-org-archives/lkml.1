Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbYCLEIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbYCLEIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYCLEIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:08:35 -0400
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104]:47975 "HELO
	n8a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750768AbYCLEIe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:08:34 -0400
X-Yahoo-Newman-Id: 745496.4156.bm@omp414.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TGFRSyvx8DVatoyg/TRdeCo1Eosh74KGK7jZyRcSXlLBsXkDUxN1TN17/trJr3Bw3BjrRl6VgbHyzaKKUEaXa1RiNOsYdqKBPPkwZZTe6kyR2dLMWMCRYK7dDTywsWtHIXiEPpzhVUCP/WtZ+uEQj6+R502tmbyiNvB6AI1T1/0=  ;
X-YMail-OSG: E5KbgCUVM1m4lyc2rJggNuTvgOMaydXHwljU8UsfYY.qmapUwDrMMq1H2s0o6I2kIG2lrjhm3g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] genhd must_check warning fix
Date: Wed, 12 Mar 2008 15:07:38 +1100
User-Agent: KMail/1.9.5
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080312001317.D68A526F991@magilla.localdomain> <200803121440.26356.nickpiggin@yahoo.com.au> <47D753AC.8080206@garzik.org>
In-Reply-To: <47D753AC.8080206@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803121507.39347.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 14:53, Jeff Garzik wrote:
> Nick Piggin wrote:
> > On Wednesday 12 March 2008 14:25, Jeff Garzik wrote:
> >> Roland McGrath wrote:
> >>> Fixes:
> >>>
> >>> 	block/genhd.c:361: warning: ignoring return value of ‘class_register’,
> >>> declared with attribute warn_unused_result
> >>>
> >>> Signed-off-by: Roland McGrath <roland@redhat.com>
> >>> ---
> >>>  block/genhd.c |    4 +++-
> >>>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/block/genhd.c b/block/genhd.c
> >>> index c44527d..00da521 100644
> >>> --- a/block/genhd.c
> >>> +++ b/block/genhd.c
> >>> @@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t devt, int
> >>> *part, void *data)
> >>>
> >>>  static int __init genhd_device_init(void)
> >>>  {
> >>> -	class_register(&block_class);
> >>> +	int error = class_register(&block_class);
> >>> +	if (unlikely(error))
> >>> +		return error;
> >>>  	bdev_map = kobj_map_init(base_probe, &block_class_lock);
> >>>  	blk_dev_init();
> >>
> >> ACK
> >>
> >> I was silly and simply tuned out this warning, assuming [wrongly] that
> >> it was difficult to fix like the fs/partitions.c warning.
> >>
> >> Shows how "helpful" those warnings are...
> >
> > I don't see why? If the warning wasn't there, then Roland probably
> > wouldn't have noticed. So to me it shows that the warning actually
> > is helpful (without "") in this case.
>
> The point was more that the warnings are so often silly that it teaches
> the human to tune out the warnings -- even when they turn out to reveal
> real problems, as in this case.

But the must_check warning? fs/partitions/check.c warning seems like it
is still a real error, whether or not it is hard to fix.


> I've been working quietly, the past several kernels, trying to kill most
> compiler warnings, so I've been paying close attention to this sort of
> stuff in general.

If you tune out the must_check warnings, then how is that better than
not having them at all? In either case, you'd have missed this genhd
bug(let).

