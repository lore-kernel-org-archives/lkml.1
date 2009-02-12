Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZBLLJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZBLLJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZBLLJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:09:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbZBLLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:09:31 -0500
Date: Thu, 12 Feb 2009 03:09:26 -0800 (PST)
Message-Id: <20090212.030926.74125778.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234434959.29851.55.camel@pasglop>
References: <20090212.021527.12463602.davem@davemloft.net>
	<1234434959.29851.55.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Feb 2009 21:35:59 +1100

> Oh BTW something else to be careful with, though I suppose it's working
> some what by accident right now... when the GART is in the frame buffer
> it gets applied the current fb swapper setting... ouch !
> 
> So it might be a good idea, if we're going to use DRM_READ/WRITE32 which
> afaik are readl/writel (ie, swapping) to make sure we at least
> temporarily disable that swapper while whacking the GART.

Cute.

I wonder if this is what is tripping me up.

But, looking more closely, it appears that:

1) The kernel radeon framebuffer driver doesn't mess with
   the framebuffer endianness setting.

2) On >= R300 (which my chip is), Xorg leaves it alone too.
