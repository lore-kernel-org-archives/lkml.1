Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbXEIHwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbXEIHwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXEIHwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:52:47 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53052 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXEIHwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:52:46 -0400
Message-ID: <46417D97.9090108@drzeus.cx>
Date: Wed, 09 May 2007 09:51:51 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au> <464169C8.9060002@drzeus.cx> <46416B9A.3020008@yahoo.com.au>
In-Reply-To: <46416B9A.3020008@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>
> If you want to ensure you always only modify host->removed from under
> the spinlock, it would be enforcable by introducing an accessor function
> and doing a BUG_ON(!spin_is_locked()) in there.
>
> If you just want to ensure that host->removed is 0 at this point, you
> shouldn't need any spinlocks AFAIKS... that way you can probably afford
> to move it out from CONFIG_MMC_DEBUG and get wider testing.
>

The host->removed member is only used for this simple test. It is set in
mmc_host_remove() to indicate that the removal process has begun. At
this point it is invalid to call mmc_detect_change() (the place this
patch fixes). So the spinlocks are mostly there so that things are
properly ordered when we go SMP. Some creative barriers would probably
work as well, but I find spinlocks more "normal" and hence more readable.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

