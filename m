Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbXE3KsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbXE3KsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXE3Kr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:47:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:49770 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXE3Krz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R715hsEPVlO7HxhwriWLS/PsTPLeuckj9g0Q/v83XX7FaOWbS0dDP3GLioTC1dCNBmagnogpu8vPU3o2000a0G6JxdIS+NYanaup5mAV8zfuyWXABXwXxJKTvuAm4fdIqwGtK6w3pSrVeg6SQtVCaRN20XO7iOyG260J3stsaFE=
Message-ID: <4cefeab80705300347gc618151we40a0cd34e6460ff@mail.gmail.com>
Date: Wed, 30 May 2007 16:17:54 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <Pine.LNX.4.61.0705301028190.11140@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <Pine.LNX.4.61.0705292236490.11140@yvahk01.tjqt.qr>
	 <4cefeab80705292254k33079e90j52a32a813b12a887@mail.gmail.com>
	 <Pine.LNX.4.61.0705301028190.11140@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 30 2007 11:24, Nitin Gupta wrote:
> >>
> >> It is the bytestream (ip) that is reinterpreted as uint16_t.
> >> And I really doubt that the LZO author has a big-endian machine,
> >> given the days of ubiquitous x86.
> >
> >> le16_to_cpu it is.
> >
> > But then why you think it should be
> > le_16_cpu() -- how will this make any difference?
>
> Like I said, we are reinterpreting the byte stream as a uint16_t
> (= reading from bytestream to CPU). While writing out an uint16_t
> as a bytestream is cpu_to_le16.
>

I didn't properly understand this. But you seem to be correct - now I
ran sparse check:

* using cpu_to_le16()
lib/lzo1x/lzo1x_decompress.c:141:35: error: incompatible types for
operation (>>)
lib/lzo1x/lzo1x_decompress.c:141:35:    left side has type restricted
unsigned short [usertype] [force] <noident>
lib/lzo1x/lzo1x_decompress.c:141:35:    right side has type int
lib/lzo1x/lzo1x_decompress.c:140:20: error: incompatible types for operation (-)
lib/lzo1x/lzo1x_decompress.c:140:20:    left side has type unsigned
char *register [assigned] op
lib/lzo1x/lzo1x_decompress.c:140:20:    right side has type bad type
lib/lzo1x/lzo1x_decompress.c:157:35: error: incompatible types for
operation (>>)
lib/lzo1x/lzo1x_decompress.c:157:35:    left side has type restricted
unsigned short [usertype] [force] <noident>
lib/lzo1x/lzo1x_decompress.c:157:35:    right side has type int
lib/lzo1x/lzo1x_decompress.c:156:11: error: incompatible types for
operation (-=)


* using le16_to_cpu()
lib/lzo1x/lzo1x_decompress.c:140:23: warning: cast to restricted type
lib/lzo1x/lzo1x_decompress.c:156:14: warning: cast to restricted type

But still, how do I get rid of these two warnings? or, do these
warning suggest some real problem that still exist in code?

- Nitin


> > For your ref (from big_endian.h):
> > # define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
> > # define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
>
>
>         Jan
> --
>
