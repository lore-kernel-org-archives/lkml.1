Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYHHHUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYHHHUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYHHHU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:20:26 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:40311 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753135AbYHHHUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:20:25 -0400
Date: Fri, 08 Aug 2008 16:20:24 +0900 (JST)
Message-Id: <20080808.162024.189720323.ryov@valinux.co.jp>
To: taka@valinux.co.jp
Cc: fernando@oss.ntt.co.jp, dave@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, uchida@ap.jp.nec.com, ngupta@google.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       righi.andrea@gmail.com
Subject: Re: RFC: I/O bandwidth controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080808.152119.43521725.taka@valinux.co.jp>
References: <1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<20080808.152119.43521725.taka@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >   - Implement a block layer resource controller. dm-ioband is a working
> > solution and feature rich but its dependency on the dm infrastructure is
> > likely to find opposition (the dm layer does not handle barriers
> > properly and the maximum size of I/O requests can be limited in some
> > cases). In such a case, we could either try to build a standalone
> > resource controller based on dm-ioband (which would probably hook into
> > generic_make_request) or try to come up with something new.
> 
> I doubt about the maximum size of I/O requests problem. You can't avoid
> this problem as far as you use device mapper modules with such a bad
> manner, even if the controller is implemented as a stand-alone controller.
> There is no limitation if you only use dm-ioband without any other device
> mapper modules.

The following is a part of source code where the limitation comes from.

dm-table.c: dm_set_device_limits()
        /*
         * Check if merge fn is supported.
         * If not we'll force DM to use PAGE_SIZE or
         * smaller I/O, just to be safe.
         */

        if (q->merge_bvec_fn && !ti->type->merge)
                rs->max_sectors =
                        min_not_zero(rs->max_sectors,
                                     (unsigned int) (PAGE_SIZE >> 9));

As far as I can find, In 2.6.27-rc1-mm1, Only some software RAID
drivers and pktcdvd driver define merge_bvec_fn().

Thanks,
Ryo Tsuruta
