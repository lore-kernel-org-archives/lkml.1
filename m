Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbXE1QER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbXE1QER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXE1QEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:04:01 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:65211 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXE1QEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uZVNhOiJTIc1Knn8boFLPVE/h/kPWJ2SZsfkcYKYIZLEe6CUELN4ElWTjrOmN1+/3fG9i7ncN+I0fVkTafevU5wDIL41YTwEIYy4x5ujyjjMJ7s6ApdfRBqfmy18jbaKaSia3D8MXhn0DzKeLYYn9GLBaIU67Zp8GOoCtVidgJk=
Message-ID: <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
Date: Mon, 28 May 2007 21:33:32 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <20070528154346.GO3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
	 <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
	 <20070528154346.GO3899@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, May 28, 2007 at 08:36:44PM +0530, Nitin Gupta wrote:
> >...
> > So, before this change, it will be good if it gets merged in mainline
> > and tested, at least for correctness, on all supported achs. All the
> > while, we will have a good feeling that there is still a good scope
> > for perf improvement :)
>
> The correct order is:
> - create one version with all the optimizations you have in mind

Already done. One more optimization is regarding use of memcpy() in
place of COPY4() macros and open byte-by-byte copying. There are some
places where it's very hard to get it correct without adding
additional checks on various values which casues futher overhead by
iteslf - even then I could not get them correct so I decided not to go
with this particular optimization by myself.

> - then ensure that it works correctly on all architectures and

Already tested on x86, amd64, ppc (by Bret). I do not have machines
from other archs available. Bret tested 'take 3' version but no
changes were introduced in further revisions that could affect
correctness - but still it will be good to have this version tested
too. Only with inclusion in -mm and testing by much wider user base
can make it to mainline (I suppose nobody uses -mm for production use
anyway).

>   document why your version is that much faster than the original
>   version and why you know your optimizations have no side effects

Replied in earlier mail regarding this.

> - then get it tested in -mm
>

This is what I am looking for :)

> After these steps, you can start considering getting it into mainline.
>


- Nitin
