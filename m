Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbYDGNQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbYDGNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbYDGNQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:16:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:64490 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbYDGNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9wTXIXD31QAlNhg8LndWFLWHX0xpJFKTJCknLF38PSllw40AAwUh2DNihEHjFroa+QYSl7QTiGi4YhhjrYiAz0mk9vJaKst5PVmzPsG+++zHtEwoVJaAYYi4iwJc6w9CS9M+Nnr+p7m3bqo89iQc7XLL7u78u76YloKazLXkVI=
Message-ID: <a72f6a3c0804070616p4c8cebfs2ad894e529ee904d@mail.gmail.com>
Date: Mon, 7 Apr 2008 14:16:03 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: "dean gaudet" <dean@arctic.org>
Subject: Re: How does Linux measure CPU frequency?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0804060935520.7751@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804060930l157ec1f5xc090dfdc3ca4a011@mail.gmail.com>
	 <alpine.DEB.1.10.0804060935520.7751@twinlark.arctic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 6, 2008 at 5:37 PM, dean gaudet <dean@arctic.org> wrote:
> linux knows what style of cpu it is running on and uses non-portable
>  techniques to read the time-stamp counter.
>
>  lmbench uses some really nice tricks to estimate the cpu frequency in a
>  portable manner... all it requires is that at least two of the N code
>  sequences it times take a co-prime number of cycles.

 The MHZ measures time by gettimeofday( ), and
 this assumes that the function gettimeofday( ) returns the actual
 real-world time elapse in microseconds, instead of some scaled time.
 What I mean here by scaled time is, Linux kernel keeps time by reading
 a counter which is increased by one when an interrupt is generated
 from a physical timer, and Linux defines the default HZ = 100 which
 means an interrupt is generated every 10 milliseconds, but without
 knowing which clock the physical timer is clocked at it is impossible
 to correctly measure 10 milliseconds by the timer. Therefore, the
 results from MHZ could be scaled? please correct me if I am wrong.

And, I believe this is the same case for Linux TSC (time stamp
counter), as the time constant of ~50ms is also measured by a
programmable interval timer which can also be scaled.

>
>  -dean
>
>
>
>  On Sun, 6 Apr 2008, Jack Harvard wrote:
>
>  > Hi,
>  >
>  > I want to find out how Linux calibrates the frequency of CPUs, and
>  > want to compare with the way how lmbench measures processor frequency.
>  > I had a thorough google search of this topic but didn't get too much
>  > useful results.
>  >
>  > Thanks a lot,
>  > Jack
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > Please read the FAQ at  http://www.tux.org/lkml/
>  >
>
