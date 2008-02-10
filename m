Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYBJRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYBJRs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYBJRsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:48:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:46238 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYBJRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZTkgv78FgKQ/cAOI/0z25kKf1BrXSJ09UJjlYpR0IwN42iIs/L/h8WDzIf4P20HdDqvQhbdWFeeqa7q0N0DS7rNvcWTsvaYiPD/O3lV6XHemOMfFqW03Fb+j6bOrHrrWhn3rovLNf40vxENH3FMlugb78t/+XhiGu/0sQ9wgOKs=
Message-ID: <6101e8c40802100948o5c5ece12h50fd2ff3ca73ce78@mail.gmail.com>
Date: Sun, 10 Feb 2008 18:48:17 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: "Bastian Blank" <bastian@waldi.eu.org>, "Niki Denev" <ndenev@gmail.com>,
       "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, stable@kernel.org
In-Reply-To: <20080210170544.GA25353@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
	 <20080210122250.GA24048@wavehammer.waldi.eu.org>
	 <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
	 <20080210124731.GA25396@wavehammer.waldi.eu.org>
	 <6101e8c40802100502g6c3c2d01ufce1ce23c7c20c5a@mail.gmail.com>
	 <20080210170544.GA25353@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks the info

On 2/10/08, Greg KH <greg@kroah.com> wrote:
> On Sun, Feb 10, 2008 at 02:02:27PM +0100, Oliver Pinter wrote:
> > thx it fixed for 2.6.22
> >
> > >>>>>>>
> >
> > commit f6e993b835393543bab2d917f9dea75218473edd
> > Author: Oliver Pinter <oliver.pntr@gmail.com>
> > Date:   Sun Feb 10 14:03:46 2008 +0100
> >
> >     [PATCH] vm: splice local root exploit fix for 2.6.22.y
> >
> >     Based on Bastian Blank's patch
> >
> >     Fix for CVE_2008_0009 and CVE_2008-0010
> >
> >     ----->8-----
> >
> >     oliver@pancs:/tmp$ ./2617_26241_root_exploit
> >     -----------------------------------
> >      Linux vmsplice Local Root Exploit
> >       By qaaz
> >       -----------------------------------
> >       [+] mmap: 0x0 .. 0x1000
> >       [+] page: 0x0
> >       [+] page: 0x20
> >       [+] mmap: 0x4000 .. 0x5000
> >       [+] page: 0x4000
> >       [+] page: 0x4020
> >       [+] mmap: 0x1000 .. 0x2000
> >       [+] page: 0x1000
> >       [+] mmap: 0xb7f1a000 .. 0xb7f4c000
> >       [-] vmsplice: Bad address
> >
> >     -----8<-----
> >
> >     Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
> >
> > diff --git a/fs/splice.c b/fs/splice.c
> > index e263d3b..d8b106e 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -1182,6 +1182,12 @@ static int get_iovec_page_array(const struct
> > iovec __user *iov,
> >  		if (unlikely(!base))
> >  			break;
> >
> > +		/* CVE-2008-0009, CVE-2008-0010 fix */
>
> No, this is a different CVE, as it is a different problem from the
> original 09 and 10 report.
>
> It has been given CVE-2008-0600 to address this issue (09 and 10 only
> affect .23 and .24 kernels, and have been fixed.)
>
> > +		if(!access_ok(VERIFY_READ, base, len)) {
> > +			error = -EFAULT;
> > +			break;
> > +		}
>
> Hm, perhaps we should just properly check the len field instead?  That's
> what is being overflowed here...
>
> thanks,
>
> greg k-h
>


-- 
Thanks,
Oliver
