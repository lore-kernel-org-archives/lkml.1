Return-Path: <linux-kernel-owner+w=401wt.eu-S1946122AbXDLJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946122AbXDLJ4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946118AbXDLJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:56:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49568 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161595AbXDLJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:56:11 -0400
Date: Thu, 12 Apr 2007 10:58:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Andreas Gruenbacher <agruen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it
 unambiguous; exclude unreachable mount points from /proc/mounts
Message-ID: <20070412105825.15f4df39@the-village.bc.nu>
In-Reply-To: <20070412090846.670863000@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090846.670863000@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Third, sys_getcwd() shouldn't return disconnected paths.  The patch checks for
> that, and makes it fail with -ENOENT in that case

That is a fairly significant and sudden change to the existing
kernel/user interface.

> Fourth, this now allows us to tell unreachable mount points from reachable
> ones when generating the /proc/mounts and /proc/$pid/mountstats files. 
> Unreachable mount points are not interesting to processes (they can't get
> there, anyway), so we hide unreachable mounts.  In particular, ordinary

This is untrue. The process can get there (via fd passing with another
task) and the process can be producing output for the human operators,
who most definitely need to know and see this stuff.

> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Reviewed-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I don't think this is fit to apply in current form. The hiding of mounts
and mountstats is the wrong approach. The changes to getcwd behaviour
bother me too as we are changing user space behaviour without warning.

The general idea of pushing some of the fail detect logic into __d_path()
seems good though.

Alan
