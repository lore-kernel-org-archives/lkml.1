Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbYDRAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbYDRAH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYDRAHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:07:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36030 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755566AbYDRAHM (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:07:12 -0400
Date: Fri, 18 Apr 2008 10:06:57 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
Message-ID: <20080418000657.GC108924158@sgi.com>
References: <200804170949.36864.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804170949.36864.denys@visp.net.lb>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 09:49:36AM +0300, Denys Fedoryshchenko wrote:
> Hi again
> 
> I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it
> is triggerable on different loaded servers with XFS (squid with aufs),
> just it is happening even on heavy load after 1-2 days. IMHO such bugs is
> critical (same as getting kernel panic, and etc),

Well, yes, and we treat shutdown bugs as such. A filesystem shutdown
is effectively a filesystem panic and is indicative of either a
corruption or a bug. The reality is that it takes time to triage
such a problem that only occurs on one workload on one set of
identical machines once every day or two. This does not make the
problem a release blocker, though.

The other side of it is that problems like this in Linux are often
the result of a bug in a lower layer and not XFS itself. Given this
particular problem seems to be memory corruption it could be anything
that is causing it....

> cause they are unrecoverable, causing minor filesystem corruption, and only
> way to fix them - wakeup sysadmin. Worst thing, it is hapenning at night,
> when i restart squid, and probably it is doing agressive unlinking stale
> cache entries. It doesn't do panic, or even oops, but filesystem will be
> disconnected, > and squid will remain in loop trying to restart. Sure it is
> easy to restart it, but maybe it has to be OOPS? so at least i can do
> sysctl -w kernel.panic_on_oops = 1, and FS will be recovered on reboot.

Rather than fearmongering, perhaps you should ask on the XFS list
(xfs@oss.sgi.com) whether anything like this can be done.  Then you
might have learnt about Documentation/filesystems/xfs.txt and
/proc/sys/fs/xfs/panic_mask:

  fs.xfs.panic_mask             (Min: 0  Default: 0  Max: 127)
        Causes certain error conditions to call BUG(). Value is a bitmask;
        AND together the tags which represent errors which should cause panics:

> Just want to warn people who is using XFS on loaded servers to keep
> attention while using 2.6.25, and if you face same bug, report to bugzilla.

Actually, I'd much prefer XFS bug reports to go to xfs@oss.sgi.com
rather than the kernel bugzilla - that way most of the XFS community
will see the bug report and the triage being done and then there's
no need for spamming lkml like this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
