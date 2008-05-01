Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbYEAXLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbYEAXLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933667AbYEAXK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:10:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:59337 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069AbYEAXKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lAt65WwanOtOMrXp3HJbkLcC1nV1dQvBjgIjycosRqiCswcZBTxPK+EBUK8ttyujTpM1U39gvCUBgbhlpznHKMQkQ51o9AdSc4ZrcG3sPk0MiAuYpYxmtoQO/cl8c0l+vONE2s41Kiukn/xNnq0oIFASziMo7F/tv0OBv1upzMk=
Message-ID: <86802c440805011610o2d3cd00cx1a4abb5d0967c712@mail.gmail.com>
Date: Thu, 1 May 2008 16:10:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <481A4ACA.10008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <481A31E2.2020800@zytor.com>
	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
	 <481A356C.5090502@zytor.com>
	 <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
	 <481A372C.5080808@zytor.com>
	 <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>
	 <481A3AD6.1040905@zytor.com>
	 <86802c440805011552t213b9badv926baeb0b4bc5227@mail.gmail.com>
	 <481A4ACA.10008@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 3:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > only search 78
> > 2g, 1g, ...1m, and half matrix 13 * 6..
> >
> > and don't need to search than 78.
> >
> >
>
>  Again, it's not clear to me why there is an inherent limit at 2 GB.

above 2g, we will use 4g (chunk size, because if use 4g gran_size will
trim too much RAM). it will get the continous layout like
0-4g WB
3.5g-4G UC

instead of discrete that we want. (chunk_size=2g, gran_size=512M)
0-2g WB
2g-4g WB
3.5g-4g UC

YH
