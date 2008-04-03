Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYDCRXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYDCRXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYDCRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:23:45 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:34969 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYDCRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AJnZ0AoHN6uQ925V6NnEsqKj1CUJrdhzrBVGpnwALjbRO64++0dRWE3JjYhpcjKW4SdSbQa6lbtw3CuTiDk1ImubjvYtpEbVCIBcGwn62clwd4mySkDMhDgTrUpOEOJ4uItXvbpUoNN/8eTDhx39mSBXLqFkGx2SfARbZeu1uYc=
Message-ID: <4cefeab80804031023m10924d6n9e21f6cb792f5d76@mail.gmail.com>
Date: Thu, 3 Apr 2008 22:53:43 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/6] compcache: TLSF Allocator interface
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1206385013.6437.140.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242034.24264.nitingupta910@gmail.com>
	 <1206377777.6437.123.camel@lappy>
	 <4cefeab80803241034m6f62c01fq669129db9959f47f@mail.gmail.com>
	 <1206385013.6437.140.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 12:26 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>  Yeah, it also suffers from a horrible coding style, can use excessive
>  amounts of vmalloc space, isn't hooked into the reclaim process as an
>  allocator should be and has a severe lack of per-cpu data making it a
>  pretty big bottleneck on anything with more than a few cores.
>
>  Now, it might be needed, might work better, and the scalability issue
>  might not be a problem when used for swap, but still, you don't treat
>  any of these points in your changelog.
>


I will add these points to changelog.
This project is meant for small systems only. So, scalability is not an issue.


>  FWIW, please split up the patches in a sane way. This series looks like
>  it wants to be 2 or 3 patches. The first introducing all of TLSF (this
>  split per file is horrible). The second doing all of the block device,
>  and a possible last doing documentation and such.
>

Ok. I will resend with better splitting.


>  Also, how bad was kmalloc() compared to this TLSF, we need numbers :-)
>
>

I have posted performance numbers at:
http://code.google.com/p/compcache/wiki/AllocatorsComparison

Data Summary:

Peak Memory Usage:

    * Ideal: 24947 KB
    * TLSF: 25377 KB
    * KMalloc(SLUB): 36483 KB

So, KMalloc uses ~43% more memory than TLSF!


- Nitin
