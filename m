Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873Ab0ALNeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0ALNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 08:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312Ab0ALNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 08:34:11 -0500
Received: from smtp.nokia.com ([192.100.105.134]:43790 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0ALNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 08:34:08 -0500
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
In-Reply-To: <4B4BB397.5090500@zytor.com>
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>
	 <20100111140255.GA1416@ucw.cz> <4B4B5768.2040005@zytor.com>
	 <20100111201734.GA11674@elf.ucw.cz>  <4B4BB397.5090500@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 15:33:26 +0200
Message-Id: <1263303206.1289.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Jan 2010 13:33:31.0910 (UTC) FILETIME=[D523A260:01CA938B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:26 -0800, H. Peter Anvin wrote:
> On 01/11/2010 12:17 PM, Pavel Machek wrote:
> >>
> >> Uhm, that's just plain wrong.
> >>
> >> It doesn't matter if there is a "special mapping layer" -- if you're
> >> crossing multiple erase blocks you're still having more churn in
> >> your flash translation layer, with more wear on the device, and
> >> lower performance than if you didn't.
> > 
> > Eraseblocks really should not matter. It is not as if each logical
> > sector belongs to one eraseblock....
> > 
> > (OTOH, maybe the eraseblock *groups* that are basis for wear-leveling
> > do, or maybe firmware is doing something really really strange.)
> > 								Pavel
> 
> Maybe they "should not" matter, but they *do* matter.  In most existing
> FTLs, each logical sector *does* belong to one erase block, although
> which particular erase block that is of course moves around.  However,
> the invariant that matters though -- and the reason alignment matters --
> is that for most FTLs, the *offset* of any particular logical sector
> within the erase block it currently belongs to is invariant, i.e. the
> FTL operates on physical sectors which are the same size as the erase
> blocks.

I think the other reason why alignment matters, at least on eMMC, is
that they most probably have several MLC NAND chips inside, and they use
"striping". And what matters is whether your I/O request is aligned to
the "striping I/O group" size or not. Yes, because the offsets are most
probably invariant.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

