Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbXGHKc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbXGHKc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXGHKct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:32:49 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1035 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753600AbXGHKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:32:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Sun, 8 Jul 2007 12:09:11 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1-cfs-v19 Unable to handle kernel NULL pointer
	dereference (reproducable)
Message-ID: <20070708100911.GA4196@gentoox2.trippelsdorf.de>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708012016.455ce8d5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 01:20:16AM -0700, Andrew Morton wrote:
> On Sun, 8 Jul 2007 07:14:52 +0200 Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> ...
> > touch src/.depend # to prevent unecessary warnings
> > make: *** [dep] Killed
> 
> ug.  nd.dentry.d_inode (as set up by do_utimes()) is garbage.  I don't know
> what could have caused that.
> 
> 
> > Running "touch  /var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/src/.depend" 
> > triggers this oops.
> 
> What type of filesystem is at /var/tmp?
> 
> Is it repeatable after a reboot?
> 

The filesystem at /var/tmp was xfs. And yes it was repeatable after a
reboot...

So I ran xfs_check on that partition and it reported errors. Then I ran
xfs_repair and after that rebooted, but the problem was still there.
Finally I switched the partition back to ext3, because it got too scary.
But the oops is now repeatable even on this new ext3 partition.

There are no errors in the smartd log. I will run "smartctl -t long" now
and will report back if it finds any errors.

-- 
Markus
