Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXFJQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXFJQQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXFJQQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:16:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXFJQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:16:33 -0400
Date: Sun, 10 Jun 2007 09:18:47 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry,
	take#2
Message-ID: <20070610161847.GA12773@kroah.com>
References: <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com> <20070522223841.GB2874@kroah.com> <4653F98A.8080308@gmail.com> <46696917.50004@gmail.com> <466A4D8A.1050809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466A4D8A.1050809@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:49:46PM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Tejun Heo wrote:
> >> Greg KH wrote:
> >>> On Mon, May 21, 2007 at 10:31:01AM +0530, Maneesh Soni wrote:
> >>>> On Thu, May 17, 2007 at 08:16:10PM +0200, Tejun Heo wrote:
> >>>>> Allowing attribute and symlink dentries to be reclaimed means
> >>>>> sd->s_dentry can change dynamically.  However, updates to the field
> >>>>> are unsynchronized leading to race conditions.  This patch adds
> >>>>> sysfs_lock and use it to synchronize updates to sd->s_dentry.
> >>>>>
> >>>>> Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
> >>>>> is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
> >>>>> validity of the dentry is protected by dcache_lock, so whether dentry
> >>>>> is alive or not can only be tested while holding both locks.
> >>>>>
> >>>>> This is minimal backport of sysfs_drop_dentry() rewrite in devel
> >>>>> branch.
> >>>>>
> >>>>> DONT APPLY JUST YET
> >>>> Looks ok to me.. I have tested it it but unfortunately I couldn't
> >>>> recreate the race without the patch also. It would be helpful if
> >>>> people actually seeing the race, provide the test results.
> >>>>
> >>>> Greg, please merge this one once we have some test results.
> >>> Can someone just resend it after those test results are in, with the
> >>> proper signed-off-by, so I know it's safe to apply?
> >> I'll resend with S-O-B after someone verifies it fixes the problem.
> > 
> > Have been trying to reproduce the problem on the latest -rc but haven't
> > succeeded yet.  It seems I lost my magic recipe for these races.  Did
> > anyone succeed?
> 
> Alright, overnight test finally hit the race condition.  It takes me
> much longer now but the race condition is definitely still there.  I'll
> verify each proposed patch and send it for 2.6.22 inclusion and if
> they're accepted to -stable.

Ok, thanks for doing this.

greg k-h
