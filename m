Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZCRMvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZCRMvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZCRMtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:49:17 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:36997 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757455AbZCRMtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:49:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ybzzLghiZi9q5NOcHWygqGRKt8L5oESZSzv8LjFCIh2MLE2jo2AzvDaEhJvhCxzQohktVXQZaHcWuvplFdVNO/CMQuWGVlqNxRi5lcDUjIzAUVDviX4LEVRyPQ/wG8wA9nOgoO92uet0Rm2yIOVqhZFHX5G2tSEPYNkd9yOUISI=  ;
X-YMail-OSG: NQL1ftIVM1k9oVWcrvAsMoJfX3USrM6uuVNeNdUBTwTDP1YL7fXYakn_jgz7uibmV_RjZun_iAEQFBUJ4QN603.UvHo87TlWPPIHvlVMh773buND6bVHf4nMafCOXEjq3Gw1bWLLeN87ZetbtoNnIRcuz1DZq.ctgeQ4vFpUkMo2xoTwcuJkke89ECG2cKiUalxArHoRpp_vIEL5GsopLweBlrxcuXR9O3_IqEU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: ngupta@vflare.org
Subject: Re: [PATCH 1/3]: compressed RAM block device
Date: Wed, 18 Mar 2009 23:49:08 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <49BF8ABC.6040805@vflare.org> <200903182325.21106.nickpiggin@yahoo.com.au> <49C0EB46.5050309@vflare.org>
In-Reply-To: <49C0EB46.5050309@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903182349.09091.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 23:38:30 Nitin Gupta wrote:
> Nick Piggin wrote:
> > On Tuesday 17 March 2009 22:36:46 Nitin Gupta wrote:
> >>   drivers/block/Kconfig     |   22 +
> >>   drivers/block/Makefile    |    1 +
> >>   drivers/block/compcache.c |  995
> >> +++++++++++++++++++++++++++++++++++++++++++++ drivers/block/compcache.h
> >> | 160 ++++++++
> >>   4 files changed, 1178 insertions(+), 0 deletions(-)
> >>
> >> Creates RAM based block device (ramzswap0) which can be used as swap
> >> device. Pages swapped to this are compressed and stored in memory
> >> itself.
> >>
> >> The module is called compcache.ko. It depends on:
> >>   - xvmalloc.ko: memory allocator
> >>   - lzo_compress.ko
> >>   - lzo_decompress.ko
> >>
> >> See Documentation/blockdev/compcache.txt for usage details.
> >>
> >> Project home: http://code.google.com/p/compcache/
> >
> > I wonder how hard it would be to make the compression code
> > use an arbitrary file or device for the storage backend rather
> > than make a new block device? Then you could make a new ram
> > block device that can swap its pages out (or even extend brd.c
> > with that functionality, or use loop on tmpfs etc).
>
> Its already done as mentioned in Documentation/blockdev/compcache.txt
> (patch 3/3) but I should have added it here also: compcache accepts
> "backing_dev" parameter for backing swap partition - this allows us to

I meant more like compressing the data then passing it down to
another device. I guess you still need to make a block device to
operate on the requests, however, so it would get more complicated
because you'd need to pass your own down.... yeah it would probably
end up being just as complex and less efficient. Ignore me then :)


> forward any R/W request to backing swap device. Currently only poorly
> compressible pages (compress length > PAGE_SIZE/2) are forwarded to
> backing_dev.


