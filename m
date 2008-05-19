Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYESIEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYESIEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYESIDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:03:45 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42760 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYESIDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:03:44 -0400
Date: Mon, 19 May 2008 10:03:39 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: [PATCH 0/9] au1xmmc updates #3
Message-ID: <20080519080339.GA21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following set of patches remove demoboard-specific code from the
au1xmmc.c driver and adds new features.

My main motivation was to let boards implement other carddetect schemes,
since on one of my boards the driver-implemented poll timer doesn't work
for some unknown reason.  But this board does have a dedicated carddetect
IRQ and card-present/card-readonly indicators which are incompatible with
the Db1200 implementation.

I also took the opportunity to clean up the drivers probe() and irq()
handlers to make it a "proper" platform device (patches #3 and #4)
and add a few other features.

Patch #1 is required to get the driver to build as a module.
Patch #2 is required to be able to load/unload the driver > 16 times.
Patches #5 and #6 implement new features.
Patch #7 does a little codingstyle cleanup, no functional changes.
Patch #8 adds an optimization to the request callback.
Patch #9 adds back pb1200 MMC activity LED support (patch #3 removes it).

patches #3-#9 are intended to be applied on top of each other, against
current mainline git (2.6.23-rc3).

Changes since V2:
- address almost all Sergei Shtylyov's comments:
  pb1200/db1200 mmc device registration moved back to original location,
  remove the au1xmmc.h header as part of codingstyle cleanup
  other nits.

- 2 more patches (#8, #9)

Changes since V1:
- fix a bug in patch #6: SDIO irq should be checked for independently
  from other irq events.
- more trivial cleanups

Db1200 users, please test!  I verified the poll timer works on one of
older boards, however since I don't have Db1200 and Pb1200 boards I'm
not sure whether the driver still works with both SD controllers enabled!

Thanks!
	Manuel Lauss
