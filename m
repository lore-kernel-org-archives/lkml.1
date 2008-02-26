Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYBZWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYBZWFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764046AbYBZWFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:05:36 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:33006 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762845AbYBZWFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:05:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Tue, 26 Feb 2008 23:04:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <20080226202044.GE3013@tuxdriver.com> <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com>
In-Reply-To: <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262304.39882.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 22:38:56 Alexey Zaytsev wrote:
> On Tue, Feb 26, 2008 at 11:20 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sat, Feb 23, 2008 at 11:20:58PM +0100, Michael Buesch wrote:
> >  > On Saturday 23 February 2008 22:32:46 Alexey Zaytsev wrote:
> >
> >
> > > > And you knew that the new driver did no work with the bcm4311
> >  > > chips, which is the sad thing.
> >  >
> >  > That is not true. It doesn't work with exactly _one_ revision
> >  > of the bcm4311 card. And that is already fixed in 2.6.25.
> >  > I'd like to have that in .24-stable, too, but I guess it's too big.
> >  > It changes some parts of the DMA engine code.
> >
> >  Which patch is it?  Is it this one?  Or is there another one that touches 4311?

Yeah, I think that's it.

> >  commit 013978b688d2a27af3ab55ca739e8c8ac7254870
> >  Author: Larry Finger <Larry.Finger@lwfinger.net>
> >  Date:   Mon Nov 26 10:29:47 2007 -0600
> >
> >     b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
> >
> >     The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
> >     has not been supported until now. The changes include the following:
> >
> >  <snip>
> >
> >  If so, perhaps we should just consider applying this to -stable?
> >
> 
> I see a few problems here:
> 
> This commit seems to depend on some commits prior to it, as it touches
> drivers/net/wireless/b43/wa.c which is absent in 2.6.24.3. When I get home,
> I'll test if it still works if you ignore wa.c

Yeah, seems so. But if you are willing to test an adjusted version, I can
probably do a backported version of this patch.
This patch is well tested and does the right thing, so I'm willing to sign
off a backported version of this.
First need to find the place in the old phy.c code that matches the new wa.c code.

> The patch may be too complex for -stable. I think there was a hard line
> count limit, like no more than 100 lines. I'm not sure if this still stands.
> 
> This  does not fix the bcm43xx driver.

It does not even touch the bcm43xx driver.
Besides that the bcm43xx driver is not broken. That's the whole reason
this damn thread started at all. So it can't be broken.

-- 
Greetings Michael.
