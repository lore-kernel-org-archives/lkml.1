Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0B1Slo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:41:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60006 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0B1Sln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:41:43 -0500
Date: Sun, 28 Feb 2010 19:41:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, #@kernel.dk, This@kernel.dk,
       line@kernel.dk, is@kernel.dk, "ignored."@kernel.dk
Subject: Re: [RFC, PATCH 0/2] Reworking seeky detection for 2.6.34
Message-ID: <20100228184140.GF5768@kernel.dk>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27 2010, Corrado Zoccolo wrote:
> 
> Hi, I'm resending the rework seeky detection patch, together with 
> the companion patch for SSDs, in order to get some testing on more
> hardware.
> 
> The first patch in the series fixes a regression introduced in 2.6.33
> for random mmap reads of more than one page, when multiple processes
> are competing for the disk.
> There is at least one HW RAID controller where it reduces performance,
> though (but this controller generally performs worse with CFQ than
> with NOOP, probably because it is performing non-work-conserving 
> I/O scheduling inside), so more testing on RAIDs is appreciated.
> 
> The second patch changes the seeky detection logic to be meaningful
> also for SSDs. A seeky request is one that doesn't utilize the full
> bandwidth for the device. For SSDs, this happens for small requests,
> regardless of their location.
> With this change, the grouping of "seeky" requests done by CFQ can
> result in a fairer distribution of disk service time among processes.

Thanks, I have applied this.

-- 
Jens Axboe

