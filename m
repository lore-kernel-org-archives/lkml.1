Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbXHXNzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbXHXNzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXHXNzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:55:10 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:35696 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757654AbXHXNzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:55:08 -0400
Message-ID: <387963704.05674@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 24 Aug 2007 21:55:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070824135504.GA9029@mail.ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <20070822011841.GA8090@mail.ustc.edu.cn> <20070823023306.GM61154114@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823023306.GM61154114@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 12:33:06PM +1000, David Chinner wrote:
> On Wed, Aug 22, 2007 at 09:18:41AM +0800, Fengguang Wu wrote:
> > On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> > Notes:
> > (1) I'm not sure inode number is correlated to disk location in
> >     filesystems other than ext2/3/4. Or parent dir?
> 
> The correspond to the exact location on disk on XFS. But, XFS has it's
> own inode clustering (see xfs_iflush) and it can't be moved up
> into the generic layers because of locking and integration into
> the transaction subsystem.
>
> > (2) It duplicates some function of elevators. Why is it necessary?
> 
> The elevators have no clue as to how the filesystem might treat adjacent
> inodes. In XFS, inode clustering is a fundamental feature of the inode
> reading and writing and that is something no elevator can hope to
> acheive....
 
Thank you. That explains the linear write curve(perfect!) in Chris' graph.

I wonder if XFS can benefit any more from the general writeback clustering.
How large would be a typical XFS cluster?

-fengguang

