Return-Path: <linux-kernel-owner+w=401wt.eu-S935533AbXEVWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533AbXEVWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbXEVWku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:40:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54393 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbXEVWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:40:49 -0400
Date: Tue, 22 May 2007 15:38:41 -0700
From: Greg KH <greg@kroah.com>
To: Maneesh Soni <maneesh@in.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry,
	take#2
Message-ID: <20070522223841.GB2874@kroah.com>
References: <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521050101.GC9214@in.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:31:01AM +0530, Maneesh Soni wrote:
> On Thu, May 17, 2007 at 08:16:10PM +0200, Tejun Heo wrote:
> > Allowing attribute and symlink dentries to be reclaimed means
> > sd->s_dentry can change dynamically.  However, updates to the field
> > are unsynchronized leading to race conditions.  This patch adds
> > sysfs_lock and use it to synchronize updates to sd->s_dentry.
> > 
> > Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
> > is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
> > validity of the dentry is protected by dcache_lock, so whether dentry
> > is alive or not can only be tested while holding both locks.
> > 
> > This is minimal backport of sysfs_drop_dentry() rewrite in devel
> > branch.
> > 
> > DONT APPLY JUST YET
> 
> Looks ok to me.. I have tested it it but unfortunately I couldn't
> recreate the race without the patch also. It would be helpful if
> people actually seeing the race, provide the test results.
> 
> Greg, please merge this one once we have some test results.

Can someone just resend it after those test results are in, with the
proper signed-off-by, so I know it's safe to apply?

thanks,

greg k-h
