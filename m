Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYBKGY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYBKGY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYBKGYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:24:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:43392 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYBKGYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jj1LWGZRMBQTLPwUzDhrYH2Yi/n7jaxUMU9M7oeYd8Rb2mSzDd0mCFYMigfFEYlKTL3h1NCcfgjTra5mYmvc0tKOSEgYTXYMnPNzm5N7OIIxx4tCg7JaSUylH9fTpXL7W8NJ1iWJ1pQ3R2qW/abTjEDnP3NKVSTyQ8fuudRFCRE=
Message-ID: <6101e8c40802102224q7d99da65we2b7b95e39453c51@mail.gmail.com>
Date: Mon, 11 Feb 2008 07:24:14 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [PATCH] splice: fix user pointer access in get_iovec_page_array()
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, bastian@waldi.eu.org, ndenev@gmail.com
In-Reply-To: <20080210233703.GR8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
	 <20080210233703.GR8953@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux pancs 2.6.22.17-opt2-cve2 #1 SMP Sun Feb 10 16:22:37 CET 2008
i686 GNU/Linux
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] mmap: 0x0 .. 0x1000
[+] page: 0x0
[+] page: 0x20
[+] mmap: 0x4000 .. 0x5000
[+] page: 0x4000
[+] page: 0x4020
[+] mmap: 0x1000 .. 0x2000
[+] page: 0x1000
[+] mmap: 0xb7f95000 .. 0xb7fc7000
[-] vmsplice: Bad address
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] addr: 0xc01112e9
[-] wtf

the patch is good for 2.6.22.y

On 2/11/08, Willy Tarreau <w@1wt.eu> wrote:
> On Sun, Feb 10, 2008 at 04:47:57PM +0200, Pekka J Enberg wrote:
> > From: Bastian Blank <bastian@waldi.eu.org>
> >
> > The commit 8811930dc74a503415b35c4a79d14fb0b408a361 ("splice: missing user
> > pointer access verification") added access_ok() to
> copy_from_user_mmap_sem()
> > which only ensures we can copy the struct iovecs from userspace to the
> kernel
> > but we also must check whether we can access the actual memory region
> pointed
> > to by the struct iovec to close the local root exploit.
> >
> > Cc: <stable@kernel.org>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> > Bastian, can I have your Signed-off-by for this, please? Oliver, Niki, can
> > you please confirm this closes the hole?
>
> Pekka, I confirm that it also closes the hole once backported to 2.6.22.
>
> Willy
>
>


-- 
Thanks,
Oliver
