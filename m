Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXHWCdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXHWCdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHWCd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:33:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39474 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbXHWCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:33:26 -0400
Date: Thu, 23 Aug 2007 12:33:06 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070823023306.GM61154114@sgi.com>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <20070822011841.GA8090@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822011841.GA8090@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:18:41AM +0800, Fengguang Wu wrote:
> On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> Notes:
> (1) I'm not sure inode number is correlated to disk location in
>     filesystems other than ext2/3/4. Or parent dir?

The correspond to the exact location on disk on XFS. But, XFS has it's
own inode clustering (see xfs_iflush) and it can't be moved up
into the generic layers because of locking and integration into
the transaction subsystem.

> (2) It duplicates some function of elevators. Why is it necessary?

The elevators have no clue as to how the filesystem might treat adjacent
inodes. In XFS, inode clustering is a fundamental feature of the inode
reading and writing and that is something no elevator can hope to
acheive....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
