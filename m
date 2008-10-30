Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYJ3OVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYJ3OVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJ3OVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:21:09 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60121 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380AbYJ3OVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:21:08 -0400
Date: Thu, 30 Oct 2008 10:21:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-ID: <20081030142103.GA14744@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:49:34AM +0200, Meelis Roos wrote:
> I get this problem nightly on 2.6.28-rc2-* kernels on a generic
> Celeron 900/Intel 815/PATA/ext3 system.
> 
> __log_wait_for_space: no transactions
> Aborting journal on device sda3.
> ext3_abort called.
> EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> Remounting filesystem read-only

How big is your journal?   What does this report?

    dumpe2fs -h /dev/sda3| grep Journal

If it's happening nightly, I assume it's because some cron job is
going off; it would be interesting to see what was going on at that time.

The other thing that would be useful would be to replace the call to
journal_abort() in __log_wait_for_space() in fs/jbd/checkpoint.c with
a BUG(), so we can get a stack backtrace and see what filesystem
operation was calling start_this_handle() (which in turn was calling
__log_wait_for_space) that is triggering this bug.

							- Ted
