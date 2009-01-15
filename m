Return-Path: <linux-kernel-owner+w=401wt.eu-S933896AbZAOX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbZAOX5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZAOX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:57:23 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:20256 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZAOX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:57:22 -0500
Message-ID: <496FCD5F.4090208@msgid.tls.msk.ru>
Date: Fri, 16 Jan 2009 02:57:19 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@google.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
References: <200901051952.58029.bzolnier@gmail.com>  <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>  <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>  <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com>  <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>  <1232035561.5966.48.camel@localhost.localdomain>  <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>  <1232046039.5966.54.camel@localhost.localdomain>  <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com> <1232061429.5966.87.camel@localhost.localdomain> <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 15 Jan 2009, James Bottomley wrote:
>> OK, so they could be calculated on the fly in the elevators, I suppose.
>> But what would the value be?  Right now we use the nonrotational flag to
>> basically not bother with plugging (no point if no seek penalty) on
>> certain events where we'd previously have waited for other I/O to join.
>> But that's really a seek penalty parameter rather than the idea of read
>> or write costing (although the elevators usually track these dynamically
>> anyway ... as part of the latency calculations but not explicitly).
> 
> ... not bother with plugging (no point if no seek penalty) ...
> 
> I thought there was considerable advantage to plugging writes
> (in case they turn out to be adjacent) on current and older
> generations of non-rotational storage?

I think it's about collecting the whole eraseblock if possible - speaking
of NAND flashes for example.

But I also think that the percentage of whole eraseblocks during writes
will be very low regardless of any plugging, UNLESS the filesystem layout
is optimized especially for that.  So such "plugging" is somewhat useless
here - again, unless an application will perform a lot of singel-byte writes
like f.e. "mscompress" version 0.3 does...  (But we honor O_SYNC so this
case is abusable anyway.)

/mjt
> 
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

