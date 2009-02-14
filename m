Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZBNI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZBNI6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZBNI6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:58:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53794
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbZBNI6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:58:09 -0500
Date: Sat, 14 Feb 2009 00:58:03 -0800 (PST)
Message-Id: <20090214.005803.234317382.davem@davemloft.net>
To: airlied@gmail.com
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970902132342k1a756475t91ede4baf571c563@mail.gmail.com>
References: <1234434959.29851.55.camel@pasglop>
	<20090213.220934.236067646.davem@davemloft.net>
	<21d7e9970902132342k1a756475t91ede4baf571c563@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Sat, 14 Feb 2009 17:42:02 +1000

> On Sat, Feb 14, 2009 at 4:09 PM, David Miller <davem@davemloft.net> wrote:
> > 1) Mis-sizes the GART table save buffer, it uses PAGE_SIZE instead
> >   of the constant 4096 to determine how many GART entries there
> >   are.  The PCI GART entries map 4096 bytes, always.  So using
> >   getpagesize() is wrong.  (see RADEONDRIGetPciAperTableSize)
> >
> >   I have this fixed in my local tree.
> 
> Oops.
> 
> > 2) It doesn't check the surface byte swapping settings, so it
> >   could be saving in one byte order and restoing in another.
> >
> >   I guess we could force RADEON_SURFACE_CNTL to zero around
> >   the two memcpy()'s done in radeon_driver.c
> 
> Might be a good plan.

I have patches for both of these things written, will submit
to the xorg-driver-ati list.

I also have a cunning plan to work around the surface swapping
GART issue in the DRM, will try that out right now.
