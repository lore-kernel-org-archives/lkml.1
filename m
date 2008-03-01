Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYCALLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYCALLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYCALLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:11:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:29471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbYCALLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PFWLmgCnBNA70RJ/a/rdR2GWTqVqnBGepBuJHPPUrUmesZfST5J0knqO0uE0BP3BmV/XN579036vMzfnDvVSn9hx6GFcYmdhJuG8mLikqndd9RdnSu8h4DRTH4X+4zK7rpAdoeCwas+qiVuZBk6/h2kEwRusvfnDNr02x1282y0=
Message-ID: <38b2ab8a0803010311v10b1537ehcef918f2c1f79912@mail.gmail.com>
Date: Sat, 1 Mar 2008 12:11:40 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       mingo@elte.hu
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
Cc: "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <38b2ab8a0802280608v2a75812boc11c7672c2d356a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
	 <38b2ab8a0802280608v2a75812boc11c7672c2d356a6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

After spending (too much) time to bisect this, I found that the looser
commit is:

c31c7d4844ea4817692ae16bf70f9c96c05a50eb
[ x86: CPA, fix alias checks ]

nvidiafb module issue seems just a consequence of this commit.

What's look suspect from the dmesg is this:

PCI: Cannot map mmconfig aperture for segment 0

Any idea what is broken on my laptop ?

BTW, I couldn't revert this commit without conflicts so I gave a test to
c31c7d4844ea4817692ae16bf70f9c96c05a50eb parents. nvidiafb could
be loaded but the system locks during gnome session start...

Thanks

On Thu, Feb 28, 2008 at 3:08 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> and here's the dmseg output...
>
>
>
>  On Thu, Feb 28, 2008 at 3:07 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>  > Hi,
>  >
>  >  I gave to the latest -rc (rc3) a test and it appears to fail to load the
>  >  nvidiafb module and the reason given is:
>  >
>  >  nvidiafb: cannot ioremap FB base
>  >
>  >  Does anybody have a clue ?
>  >
>  >  Full dmesg output is attached.
>  >
>  >  Thanks
>  >  --
>  >  Francis
>  >
>
>
>
>  --
>  Francis
>



-- 
Francis
