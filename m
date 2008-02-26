Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYBZVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYBZVjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762661AbYBZVi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:38:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:56128 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762562AbYBZVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YM2Mef/z+A/40nCFNle0mN8DB4ijxZ9Lmp0fkzkv1A5H2Rq0T1IlxieePAHk/Vy+mmVnqaYC4xsIxmHj7cg1vDMkJEjHLQOuOZ1hZI0BvpBShqhMrA8L1Fs2CVzrrIibOG+krorFgvnBRWnWgIicKqAxJlZWb8mlWCAajp+JUhU=
Message-ID: <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com>
Date: Wed, 27 Feb 2008 00:38:56 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080226202044.GE3013@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802231727.54351.mb@bu3sch.de>
	 <f19298770802231332x79c0395fl5519e79ae75da0aa@mail.gmail.com>
	 <200802232320.58562.mb@bu3sch.de>
	 <20080226202044.GE3013@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:20 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Feb 23, 2008 at 11:20:58PM +0100, Michael Buesch wrote:
>  > On Saturday 23 February 2008 22:32:46 Alexey Zaytsev wrote:
>
>
> > > And you knew that the new driver did no work with the bcm4311
>  > > chips, which is the sad thing.
>  >
>  > That is not true. It doesn't work with exactly _one_ revision
>  > of the bcm4311 card. And that is already fixed in 2.6.25.
>  > I'd like to have that in .24-stable, too, but I guess it's too big.
>  > It changes some parts of the DMA engine code.
>
>  Which patch is it?  Is it this one?  Or is there another one that touches 4311?
>
>  commit 013978b688d2a27af3ab55ca739e8c8ac7254870
>  Author: Larry Finger <Larry.Finger@lwfinger.net>
>  Date:   Mon Nov 26 10:29:47 2007 -0600
>
>     b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
>
>     The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
>     has not been supported until now. The changes include the following:
>
>  <snip>
>
>  If so, perhaps we should just consider applying this to -stable?
>

I see a few problems here:

This commit seems to depend on some commits prior to it, as it touches
drivers/net/wireless/b43/wa.c which is absent in 2.6.24.3. When I get home,
I'll test if it still works if you ignore wa.c

The patch may be too complex for -stable. I think there was a hard line
count limit, like no more than 100 lines. I'm not sure if this still stands.

This  does not fix the bcm43xx driver.

>  I really do wish everyone would tone down their rhetoric on this
>  issue...
>
>  John
>  --
>  John W. Linville
>  linville@tuxdriver.com
>
