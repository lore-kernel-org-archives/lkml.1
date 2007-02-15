Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXBOTGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXBOTGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030555AbXBOTGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:06:05 -0500
Received: from pat.uio.no ([129.240.10.15]:36418 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030582AbXBOTGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:06:03 -0500
Subject: Re: 2.6.19.2 nfs BUG: warning at
	mm/truncate.c:398/invalidate_inode_pages2_range()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org,
       Linux NFS mailing list <nfs@lists.sourceforge.net>
In-Reply-To: <20070215185228.GA3181@janus>
References: <20070215185228.GA3181@janus>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 11:06:01 -0800
Message-Id: <1171566361.7333.34.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 9AA669B1A9BB48A477F086F725523B673D7B816B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 66 total 489200 max/h 2716 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 19:52 +0100, Frank van Maarseveen wrote:
> FYI,
> 
> Just captured this one, I'm not sure it's NFS at fault because I saw
> at least another AIO related mm/truncate.c:398 report with a totally
> different stack trace.
> 
> The machine seems still running happily, as usual with a considerable
> load. kernel is tainted by fglrx.
> 
> kernel: BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
> kernel:  [<c0104897>] dump_trace+0x227/0x240
> kernel:  [<c010498f>] show_trace_log_lvl+0x2f/0x50
> kernel:  [<c01049d7>] show_trace+0x27/0x30
> kernel:  [<c0104b06>] dump_stack+0x26/0x30
> kernel:  [<c015a495>] invalidate_inode_pages2_range+0x305/0x310
> kernel:  [<c015a4c1>] invalidate_inode_pages2+0x21/0x30
> kernel:  [<c01f7aa8>] nfs_revalidate_mapping+0x98/0x180
> kernel:  [<c01f5726>] nfs_file_read+0x46/0xb0
> kernel:  [<c017441e>] do_sync_read+0xde/0x130
> kernel:  [<c0174511>] vfs_read+0xa1/0x1b0
> kernel:  [<c0174947>] sys_read+0x47/0x70
> kernel:  [<c0103387>] syscall_call+0x7/0xb
> kernel:  [<b7ec0cbe>] 0xb7ec0cbe
> kernel:  =======================

That is a known issue. The warning was bogus after we fixed up the NFS
client to handle the case where invalidate_inode_pages2() returns and
error, and so the warning was removed in 2.6.20.

Cheers
  Trond

