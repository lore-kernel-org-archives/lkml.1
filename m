Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYEVCj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYEVCj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 22:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYEVCjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 22:39:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:30202 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYEVCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 22:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nUs69gxZowoz07rOL3PSMmtp1MpjsxJjppy7bLBm54ozSvFZvT0MR97VnlxAhpwgwDYZu41m6KXLaDKkvuWao3+ME21c0LIbYU3Vc/1cq8IBSZiwcVB/wvtphELy48v8a91ET4x+AV2IQ7WKy0OX4dZ8L7m/M5PGPqQkzjaRR4k=
Message-ID: <1820d69d0805211939u7476ead9pe17946f5d4ee7248@mail.gmail.com>
Date: Thu, 22 May 2008 04:39:16 +0200
From: "Gabriel C" <nix.or.die@googlemail.com>
To: "Tony Breeds" <tony@bakeyournoodle.com>
Subject: Re: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix compiler warnings
Cc: rolandd@cisco.com, "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, linux-next@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080522002335.GG20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48342C6C.2010502@googlemail.com>
	 <20080522002335.GG20457@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Tony Breeds <tony@bakeyournoodle.com>:
>
> On Wed, May 21, 2008 at 04:06:36PM +0200, Gabriel C wrote:
> > On linux-next from today , allmodconfig, I see the following warnings on 64bit:
>
> x86_64 right?
>
> <snip>
>
> > diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
> > index 3697449..5f80151 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_sdma.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
> > @@ -257,7 +257,7 @@ static void sdma_abort_task(unsigned long opaque)
> >       /* everything is stopped, time to clean up and restart */
> >       if (status == IPATH_SDMA_ABORT_ABORTED) {
> >               struct ipath_sdma_txreq *txp, *txpnext;
> > -             u64 hwstatus;
> > +             unsigned long hwstatus;
> >               int notify = 0;
> >
> >               hwstatus = ipath_read_kreg64(dd,
>
> This can't be right.  hwstatus needs to be u64, as that's what ipath_read_kreg64() retuns.
> and a little bit further down we see:
>
> ---
> if (/* ScoreBoardDrainInProg */
>    test_bit(63, &hwstatus) ||
>    /* AbortInProg */
>    test_bit(62, &hwstatus) ||
>    /* InternalSDmaEnable */
>    test_bit(61, &hwstatus) ||
> ---
>
> so hwstatus, clearly needs to be 64-bits.

Hmm , right it need be 64-bits.

I should drink my coffee first and read code more carefully
before sending out wrong patches , sorry.

> This brings up an interesting point.  test_bit() and co are
> essntally expecting to be passed the address
> of an unsigned long[], so is it correct to pass &u64?

I'm not sure about this one.

>
> Yours Tony
>

Gabriel
