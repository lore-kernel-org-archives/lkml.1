Return-Path: <linux-kernel-owner+w=401wt.eu-S965489AbXCOGXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbXCOGXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXCOGXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:23:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24946 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489AbXCOGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:23:50 -0400
Date: Wed, 14 Mar 2007 23:23:05 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315062305.GA20528@ca-server1.us.oracle.com>
Mail-Followup-To: Nick Piggin <npiggin@suse.de>,
	Mark Fasheh <mark.fasheh@oracle.com>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <20070315041329.GB21942@ca-server1.us.oracle.com> <20070315043642.GF15069@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315043642.GF15069@wotan.suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 05:36:42AM +0100, Nick Piggin wrote:
> On Wed, Mar 14, 2007 at 09:13:29PM -0700, Mark Fasheh wrote:
> > Are we going to get rid of the file and intr arguments btw? I'm not sure
> > intr is useful, and mapping is probably enough to get whatever we inside
> > ->write_begin / ->write_end.
> 
> Yeah, I was going to, but I had this version ready to go so decided
> to leave them in at the last minute. We can definitely take them out
> if people agree.

	You're really going to need the file argument around.  Some
folks care about file->private_data, etc.  A good example is
nfs_updatepage() from nfs_commit_write().  There's a context on the
filp.  Mapping can get back to the inode via ->host, but not to the
struct file.

Joel

-- 

Life's Little Instruction Book #157 

	"Take time to smell the roses."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
