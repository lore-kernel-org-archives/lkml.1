Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXKISop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXKISop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXKISoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:44:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54168 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbXKISog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:44:36 -0500
Subject: Re: OOPSes + WARNING: at fs/file_table.c:262 __fput() in -mm
	2007-11-06-02-32++
From: Dave Hansen <haveblue@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200711091823.lA9IN9Bp000989@agora.fsl.cs.sunysb.edu>
References: <200711091823.lA9IN9Bp000989@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 10:44:13 -0800
Message-Id: <1194633853.7078.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 13:23 -0500, Erez Zadok wrote:
> 
> Setup: FC6 system with MM snapshot broken-out-2007-11-06-02-32 and
> these two
> patches added:
> 
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
> 
> All I do is  boot the system with said kernel, wait a few seconds,
> then shut
> it down with "init 0".  As services shutdown, I get this:
> 
> Stopping RPC idmapd:
> 
> kernel: __fput() of writeable file with no mnt_want_write()
> kernel: WARNING: at fs/file_table.c:262 __fput()
> kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
> kernel:  [<c0103042>] show_trace+0xd/0x10
> kernel:  [<c010313e>] dump_stack+0x15/0x17
> kernel:  [<c01491a4>] __fput+0x153/0x203
> kernel:  [<c014952d>] fput+0x2d/0x32
> kernel:  [<c0146c8a>] filp_close+0x50/0x5a
> kernel:  [<c01104fc>] put_files_struct+0x7c/0xbe
> kernel:  [<c0110575>] __exit_files+0x37/0x3c
> kernel:  [<c01115de>] do_exit+0x1ed/0x653
> kernel:  [<c0111ab2>] sys_exit_group+0x0/0x11
> kernel:  [<c01183fc>] get_signal_to_deliver+0x3c4/0x3e8
> kernel:  [<c0101873>] do_notify_resume+0x8c/0x6c4
> kernel:  [<c0102339>] work_notifysig+0x13/0x1a 

This looks like RPC idmapd had a file open for write when it tried to
exit.  However, that file never had a mnt_want_write() taken for it.
This isn't a new bug, but the new debugging code found it much faster.

I'm looking for a fix now.

-- Dave

