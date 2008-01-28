Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYA1STA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYA1STA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYA1SSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:18:49 -0500
Received: from yorgi.telenet-ops.be ([195.130.133.69]:57089 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYA1SSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:18:48 -0500
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 13:18:48 EST
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Frederik Himpe <fhimpe@telenet.be>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200801281246.24043.nickpiggin@yahoo.com.au>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221625.58615.nickpiggin@yahoo.com.au>
	 <1201354155.6853.4.camel@Anastacia>
	 <200801281246.24043.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Mon, 28 Jan 2008 19:05:29 +0100
Message-Id: <1201543529.13883.1.camel@Anastacia>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5-1mdv2008.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ma, 2008-01-28 at 12:46 +1100, Nick Piggin wrote:
> On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> > On di, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > > > > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > > > > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > > > > > reader starts using 100% of CPU time after some time. When this
> > > > > > happens, kill -9 does not work, and strace just hangs when trying
> > > > > > to attach to the process. The same with gdb. ﻿ps shows the process
> > > > > > as being in the R state.
> > > > > >
> > > > > > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > > > > > Jan 21 21:45:01 Anastacia kernel: pan           R  running task
> > > > > > 0
> > >
> > > Nasty. The attached patch is something really simple that can sometimes
> > > help. sysrq+p is also an option, if you're on a UP system.
> > >
> > > Any luck getting traces?
> >
> > I just succeeded to reproduce the problem with this patch. Does this
> > smell like an XFS problem?
> >
> > Jan 26 14:17:43 Anastacia kernel: pan           R  running task        0 
> > 7564      1 Jan 26 14:17:43 Anastacia kernel:  000000003f5b3248
> > 0000000000001000 ffffffff880c28b0 0000000000000000 Jan 26 14:17:43
> > Anastacia kernel:  ffff81003f5b3248 ffff81002d1ed900 000000002d1ed900
> > 0000000000000000 Jan 26 14:17:43 Anastacia kernel:  ffff810016050dd0
> > fffff000fffff000 0000000000000000 ffff81002d1eda10 Jan 26 14:17:43
> > Anastacia kernel: Call Trace:
> > Jan 26 14:17:43 Anastacia kernel:  [_end+127964408/2129947720]
> > :xfs:xfs_get_blocks+0x0/0x10 Jan 26 14:17:43 Anastacia kernel: 
> > [unix_poll+0/176] unix_poll+0x0/0xb0 Jan 26 14:17:43 Anastacia kernel: 
> > [_end+127964408/2129947720] :xfs:xfs_get_blocks+0x0/0x10 Jan 26 14:17:43
> > Anastacia kernel:  [iov_iter_copy_from_user_atomic+65/160]
> > iov_iter_copy_from_user_atomic+0x41/0xa0 Jan 26 14:17:43 Anastacia kernel: 
> > [iov_iter_copy_from_user_atomic+46/160]
> > iov_iter_copy_from_user_atomic+0x2e/0xa0 Jan 26 14:17:43 Anastacia kernel: 
> > [generic_file_buffered_write+383/1728]
> 
> Well after trying a lot of writev combinations, I've reproduced a hang
> *hangs head*.
> 
> Does this help?

I'm currently running with this patch. The problem happens about two
times a week, so it will take a few days to come to a conclusion whether
it is fixed. I'll let you all know.

Thanks for the patch!

-- 
Frederik Himpe <fhimpe@telenet.be>

