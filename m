Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbYEGErZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbYEGErZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYEGErQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:47:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:22950 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753737AbYEGErP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:47:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="561682789"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080506205930.91ec78b6.akpm@linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>
	 <1210131712.3453.43.camel@ymzhang>
	 <20080506205930.91ec78b6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2008 12:46:16 +0800
Message-Id: <1210135576.3453.51.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 20:59 -0700, Andrew Morton wrote:
> On Wed, 07 May 2008 11:41:52 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> 
> > As system idle is more than 50%, so the schedule/schedule_timeout caller is important
> > information.
> > 1) lock_kernel causes most schedule/schedule_timeout;
> > 2) When lock_kernel calls down, then __down, __down calls ___schedule_timeout for
> > lots of times in a loop;
> 
> Really?  Are you sure?  That would imply that we keep on waking up tasks
> which then fail to acquire the lock.  But the code pretty plainly doesn't
> do that.
Yes, totally based on the data.
The data means the calling times among functions. Initially , I just collected the caller
of schedule and schedule_timeout. Then I found most schedule/schedule_timeout are called by
__down which is called down. Then, I changes kernel to collect more functions' calling info.

If comparing the calling times of down, __down and schedule_timeout, we could find
﻿schedule_timeout is called by ﻿__down for 222330308, but __down is called only for ﻿153190.

> 
> Odd.
> 
> > 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
> Still :(
Yes. The data has an error difference, but the difference is small. My patch doesn't
use lock to protect data in case it might introduces too much overhead.


