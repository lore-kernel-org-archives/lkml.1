Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZLVMey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZLVMey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZLVMex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:34:53 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:36111 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbZLVMev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:34:51 -0500
Date: Tue, 22 Dec 2009 23:34:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Blake <ebb9@byu.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>
Subject: Re: utimensat fails to update ctime
Message-ID: <20091222123436.GC9611@discord.disaster>
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp> <4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net> <87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B304D04.6040501@byu.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 09:37:24PM -0700, Eric Blake wrote:
> According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
> >> It may also be file-system dependent.  On the machine where I saw the
> >> original failure:
> >>> $ uname -a
> >>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
> >>> x86_64 GNU/Linux
> >> $ df -T .
> >> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> >> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
> > 
> > Thanks.
> > 
> > This is good point. This would be xfs issue or design. xfs seems to have
> > own special handling of ctime.

Yeah, it looks like the change to utimesat() back in 2.6.26 for
posix conformance made ATTR_CTIME appear outside inode truncation
and XFS wasn't updated for this change in behaviour at the VFS level.
Looks simple to fix, but I'm worried about introducing other
unintended ctime modifications - is there a test suite that checks
posix compliant atime/mtime/ctime behaviour around anywhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
