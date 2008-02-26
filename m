Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbYBZWMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbYBZWMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYBZWMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:12:36 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:47828 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYBZWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iZlCvImfsUrVZbQa2f5+RyzRjlrH8uase9+p8xCegaBq1nySpFoJLaC66LhOWZUahRVZk+2M3+EMxy0tjbrS53vfbzyaHfD5tbrHhBqA0taLxY41xEbX5/VwuFKL7djVtCEmmqFah8X+aMK8I581Ga+ozhkvwscYeVueEEUZRe8=
Message-ID: <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
Date: Wed, 27 Feb 2008 01:12:32 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802262304.39882.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <20080226202044.GE3013@tuxdriver.com>
	 <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com>
	 <200802262304.39882.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 26 February 2008 22:38:56 Alexey Zaytsev wrote:
>  > On Tue, Feb 26, 2008 at 11:20 PM, John W. Linville
>  > <linville@tuxdriver.com> wrote:
>  > > On Sat, Feb 23, 2008 at 11:20:58PM +0100, Michael Buesch wrote:
>  > >  > On Saturday 23 February 2008 22:32:46 Alexey Zaytsev wrote:
>  > >
>  > >
>  > > > > And you knew that the new driver did no work with the bcm4311
>  > >  > > chips, which is the sad thing.
>  > >  >
>  > >  > That is not true. It doesn't work with exactly _one_ revision
>  > >  > of the bcm4311 card. And that is already fixed in 2.6.25.
>  > >  > I'd like to have that in .24-stable, too, but I guess it's too big.
>  > >  > It changes some parts of the DMA engine code.
>  > >
>  > >  Which patch is it?  Is it this one?  Or is there another one that touches 4311?
>
>  Yeah, I think that's it.
>
>
>  > >  commit 013978b688d2a27af3ab55ca739e8c8ac7254870
>  > >  Author: Larry Finger <Larry.Finger@lwfinger.net>
>  > >  Date:   Mon Nov 26 10:29:47 2007 -0600
>  > >
>  > >     b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
>  > >
>  > >     The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
>  > >     has not been supported until now. The changes include the following:
>  > >
>  > >  <snip>
>  > >
>  > >  If so, perhaps we should just consider applying this to -stable?
>  > >
>  >
>  > I see a few problems here:
>  >
>  > This commit seems to depend on some commits prior to it, as it touches
>  > drivers/net/wireless/b43/wa.c which is absent in 2.6.24.3. When I get home,
>  > I'll test if it still works if you ignore wa.c
>
>  Yeah, seems so. But if you are willing to test an adjusted version, I can
>  probably do a backported version of this patch.
>  This patch is well tested and does the right thing, so I'm willing to sign
>  off a backported version of this.
>  First need to find the place in the old phy.c code that matches the new wa.c code.
>
I'll do the testing.

>
>  > The patch may be too complex for -stable. I think there was a hard line
>  > count limit, like no more than 100 lines. I'm not sure if this still stands.
>  >
>  > This  does not fix the bcm43xx driver.
>
>  It does not even touch the bcm43xx driver.
>  Besides that the bcm43xx driver is not broken. That's the whole reason
>  this damn thread started at all. So it can't be broken.
>
Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
any module magic.


>  --
>  Greetings Michael.
>
