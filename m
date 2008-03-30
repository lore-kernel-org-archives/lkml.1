Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYC3M2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYC3M2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYC3M20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 08:28:26 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52560 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYC3M2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 08:28:25 -0400
Date: Sun, 30 Mar 2008 21:29:06 +0900 (JST)
Message-Id: <20080330.212906.75185185.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marc.pignat@hevs.ch, nforrester@whoi.edu
Subject: Re: [PATCH] atmel_spi: support zero length transfer (resend)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080329175651.311b4f6d@hskinnemo-gx620.norway.atmel.com>
References: <20080330.001133.108307862.anemo@mba.ocn.ne.jp>
	<20080329175651.311b4f6d@hskinnemo-gx620.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 17:56:51 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > Though some discussion about zero length transfer were raised by this
> > patch last time, I think there were no explicit objection to this
> > patch itself.
> 
> Well, the patch doesn't seem to do any harm, but I can't see much of a
> point to it either if zero-length transfers aren't going to be
> allowed...

Well, some wired device might want long delay before first CLK edge.
I think most device do not have such constraint, but ...

Anyway, SPI framework does not reject it.  So I think the controller
driver should accept it unless it is hard to support on that hardware.

> Also, if the length is zero, the driver will end up doing a memset with
> length zero at some point. Is that allowed?

I believe memset() with zero length should be allowed.  It seems
ambiguous that dma_sync_single_for_device() with zero length is legal
or not.  Actually, it seems OK on ARM and AVR32.

---
Atsushi Nemoto
