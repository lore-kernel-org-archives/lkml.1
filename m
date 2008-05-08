Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYEHIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYEHIB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbYEHIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:00:45 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:37961 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYEHIAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:00:43 -0400
Date: Thu, 8 May 2008 10:00:40 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] au1xmmc updates, #2
Message-ID: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following set of patches remove demoboard-specific code from the
au1xmmc.c driver and add new features.

My main motivation was to let boards implement other carddetect schemes,
since on one of my boards the driver-implemented poll timer doesn't work
for some unknown reason.  But this board does have a dedicated carddetect
IRQ and card-present/card-readonly indicators which are incompatible with
the Db1200 implementation.  I also took the opportunity to clean up the
drivers probe() and irq() handlers to make it a "proper" platform device
(patches #3 and #4).

Patch #1 is required to get the driver to build as a module.
Patch #2 is required to be able to load/unload the driver > 16 times.
Patches #5 and #6 implement new features.
Patch #7 does a little codingstyle cleanup, no functional changes.

Change since V1:
- fix a bug in patch #6: SDIO irq should be checked for independently
  from other irq events.
- more trivial cleanups

Db1200 users, please test!  I verified the poll timer works on one of
older boards, however since I don't have Db1200 and Pb1200 boards I'm
not sure whether the driver still works with both SD controllers enabled!

Thanks!
	Manuel Lauss
