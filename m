Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZG3Ix2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZG3Ix2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZG3Ix0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:53:26 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:33256 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZG3IxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:53:24 -0400
Date: Thu, 30 Jul 2009 17:53:21 +0900 (JST)
Message-Id: <20090730.175321.193708040.ryov@valinux.co.jp>
To: horms@verge.net.au
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH] dm-ioband-v1.12.2: I/O bandwidth controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090730054204.GA11291@verge.net.au>
References: <20090730.115454.226775179.ryov@valinux.co.jp>
	<20090730054204.GA11291@verge.net.au>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> Hi Tsuruta-san,
> 
> have you run sparse over this code? There seem to be a few interesting
> warnings generated (and some at the top noise too).

Thank you for your comment.
I'll do sparse every time from now on.
 
> $ make C=1 CF="-D__CHECK_ENDIAN__"
> [snip]
> include/trace/events/dm-ioband.h:9:1: warning: symbol 'ftrace_raw_output_ioband_hold_urgent_bio' was not declared. Should it be static?
[snip ftrace warnings]

> drivers/md/dm-ioband-ctl.c:178:2: warning: context problem in 'suspend_ioband_device': '_spin_unlock_irqrestore' expected different context
> drivers/md/dm-ioband-ctl.c:178:2:    context 'lock': wanted >= 1, got 0
> drivers/md/dm-ioband-ctl.c:600:3: warning: context imbalance in 'prevent_burst_bios': unexpected unlock
> drivers/md/dm-ioband-ctl.c:600:3:    context '<noident>': wanted 0, got -1
> drivers/md/dm-ioband-ctl.c:816:3: warning: context imbalance in 'ioband_map': __context__ statement expected different context
> drivers/md/dm-ioband-ctl.c:816:3:    context '<noident>': wanted >= 0, got -1
> drivers/md/dm-ioband-rangebw.c:287:4: warning: context imbalance in 'range_bw_queue_full': __context__ statement expected different context
> drivers/md/dm-ioband-rangebw.c:287:4:    context '<noident>': wanted >= 0, got -1

These imbalances are not warned by the latest sparse command retrieved
from the git repository, and actually they are not imbalanced.

> drivers/md/dm-ioband-rangebw.c:592:6: warning: symbol 'range_bw_timeover' was not declared. Should it be static?
> drivers/md/dm-ioband-rangebw.c:210: warning: 'io_mode' may be used uninitialized in this function

I'll fix these warnings and post the update soon.

Thanks,
Ryo Tsuruta
