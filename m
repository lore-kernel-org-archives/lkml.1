Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYJ3Une@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYJ3Une (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYJ3Un2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:43:28 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36188 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYJ3Un1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:43:27 -0400
Date: Thu, 30 Oct 2008 22:43:25 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Theodore Tso <tytso@mit.edu>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
In-Reply-To: <20081030142103.GA14744@mit.edu>
Message-ID: <Pine.SOC.4.64.0810302133040.6084@math.ut.ee>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081030142103.GA14744@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > __log_wait_for_space: no transactions
> > Aborting journal on device sda3.
> > ext3_abort called.
> > EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> > Remounting filesystem read-only
> 
> How big is your journal?   What does this report?
> 
>     dumpe2fs -h /dev/sda3| grep Journal

dumpe2fs 1.41.3 (12-Oct-2008)
Journal inode:            8
Journal backup:           inode blocks
Journal size:             32M

> The other thing that would be useful would be to replace the call to
> journal_abort() in __log_wait_for_space() in fs/jbd/checkpoint.c with
> a BUG(), so we can get a stack backtrace and see what filesystem
> operation was calling start_this_handle() (which in turn was calling
> __log_wait_for_space) that is triggering this bug.

Will try.

-- 
Meelis Roos (mroos@linux.ee)
