Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbYJaOHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbYJaOHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYJaOHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:07:46 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37814 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbYJaOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:07:45 -0400
Date: Fri, 31 Oct 2008 10:07:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-ID: <20081031140742.GA17651@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081030142103.GA14744@mit.edu> <Pine.SOC.4.64.0810302133040.6084@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0810302133040.6084@math.ut.ee>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:43:25PM +0200, Meelis Roos wrote:
> > > __log_wait_for_space: no transactions
> > > Aborting journal on device sda3.
> > > ext3_abort called.
> > > EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> > > Remounting filesystem read-only
> > 
> > How big is your journal?   What does this report?
> > 
> >     dumpe2fs -h /dev/sda3| grep Journal
> 
> dumpe2fs 1.41.3 (12-Oct-2008)
> Journal inode:            8
> Journal backup:           inode blocks
> Journal size:             32M

You'll almost certainly get much better performance if you increase
your journal size.  I should make the crash go away, too, although I
would like to figure out what is going on so we can fix it.

But, if you're tired of your machine crashing, it should be possible
to deal with the problem by umounting the filesystem (assuming this is
not your root filesystem; if it is, you'll have to boot into a rescue
CD) and doing:

tune2fs -O ^has_journal /dev/sda3
tune2fs -O has_journal -J size=128 /dev/sda3

In the meantime, you say this happens nightly.  Can you take a look at
the time when it normally crashes and see if you can correlate it to
some cron job activity?  Maybe that will be a hint as to what is
triggering it.

Thanks,

						- Ted
