Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYCLDq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYCLDq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYCLDqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:46:21 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:47384 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751518AbYCLDqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:46:20 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 23:46:20 EDT
X-Yahoo-Newman-Id: 264811.25102.bm@omp404.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Th4rmbgDGjv6DtWwaobF4dB72D765COWUe+zIVwYysZ88ef96mHBisCcJdIdQsVy/frdCwGyfXkY7+3Drwu6ISlyQjCLT22FOlMBy2D/zL4psgbmEwE5sXxlUVownsvA186n/0s4OlP6U+4c+y+arLTuLWEmArcLa7hq7PaiDKg=  ;
X-YMail-OSG: c6CUm8cVM1mI_NTkr9ZUKS47LyWVa5CEYICbmRMbt16TZkck
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] genhd must_check warning fix
Date: Wed, 12 Mar 2008 14:40:26 +1100
User-Agent: KMail/1.9.5
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080312001317.D68A526F991@magilla.localdomain> <47D74D0E.8090308@garzik.org>
In-Reply-To: <47D74D0E.8090308@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803121440.26356.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 14:25, Jeff Garzik wrote:
> Roland McGrath wrote:
> > Fixes:
> >
> > 	block/genhd.c:361: warning: ignoring return value of ‘class_register’,
> > declared with attribute warn_unused_result
> >
> > Signed-off-by: Roland McGrath <roland@redhat.com>
> > ---
> >  block/genhd.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/block/genhd.c b/block/genhd.c
> > index c44527d..00da521 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t devt, int
> > *part, void *data)
> >
> >  static int __init genhd_device_init(void)
> >  {
> > -	class_register(&block_class);
> > +	int error = class_register(&block_class);
> > +	if (unlikely(error))
> > +		return error;
> >  	bdev_map = kobj_map_init(base_probe, &block_class_lock);
> >  	blk_dev_init();
>
> ACK
>
> I was silly and simply tuned out this warning, assuming [wrongly] that
> it was difficult to fix like the fs/partitions.c warning.
>
> Shows how "helpful" those warnings are...

I don't see why? If the warning wasn't there, then Roland probably
wouldn't have noticed. So to me it shows that the warning actually
is helpful (without "") in this case.

