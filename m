Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZAPDxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZAPDxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZAPDwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:52:55 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:38455 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZAPDwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EdlbGx5XQyoBOv7WJTp+3okf+jg6kGDtDpX6pKjEWh+epEfwWwbGok/PSTOpRaom/S
         1JzRMwZA6yshMydePhfm37DcGmPLn2d3P0Mt4ap8B3hvqXeMmaG4mQh2+Z20oEk/1Tjt
         yNDcCNQjLT4W2VkF41LalElNSVrYAewRb3vns=
MIME-Version: 1.0
In-Reply-To: <1232066174.5966.92.camel@localhost.localdomain>
References: <200901051952.58029.bzolnier@gmail.com> <496ECBA0.60209@gmail.com>
	 <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
	 <1232035561.5966.48.camel@localhost.localdomain>
	 <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>
	 <1232046039.5966.54.camel@localhost.localdomain>
	 <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
	 <1232061429.5966.87.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
	 <1232066174.5966.92.camel@localhost.localdomain>
Date: Fri, 16 Jan 2009 12:52:51 +0900
Message-ID: <7fe698080901151952u4c6157d3tca8d745b69cacc1e@mail.gmail.com>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
From: Dongjun Shin <djshin90@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hugh Dickins <hugh@veritas.com>, Grant Grundler <grundler@google.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 9:36 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Thu, 2009-01-15 at 23:50 +0000, Hugh Dickins wrote:
> > On Thu, 15 Jan 2009, James Bottomley wrote:
> > >
> > > OK, so they could be calculated on the fly in the elevators, I suppose.
> > > But what would the value be?  Right now we use the nonrotational flag to
> > > basically not bother with plugging (no point if no seek penalty) on
> > > certain events where we'd previously have waited for other I/O to join.
> > > But that's really a seek penalty parameter rather than the idea of read
> > > or write costing (although the elevators usually track these dynamically
> > > anyway ... as part of the latency calculations but not explicitly).
> >
> > ... not bother with plugging (no point if no seek penalty) ...
> >
> > I thought there was considerable advantage to plugging writes
> > (in case they turn out to be adjacent) on current and older
> > generations of non-rotational storage?
>
> Heh, you get as many answers to that one as their are SSD manufacturers.
> However, the consensus seems to be that all MLC and SLC flash has a RAID
> like architecture internally, thus it can actually be *faster* if you
> send multiple commands (each area of the RAID processes independently).
> Of course, you have to be *able* to send multiple commands, so the
> device must implement TCQ/NCQ, but if it does, it's actually beneficial
> *not* to wait even if the requests are adjacent.
>
> However, the reason the nonrotational flag is set from user space is
> precisely so if we do find an SSD that has this property, we can just
> not set the nonrotational queue flag.
>

Not all non-rotational SSDs are created equal (as Intel said).

Some SSD performs better as the I/O queue length increase, while others not.
For SSD with scalable queueing performance, it might be better to allow
multiple discrete I/Os.

I'm not sure if "non-rotational" is well suited for tuning the
behavior of elevator merging.

--
Dongjun
