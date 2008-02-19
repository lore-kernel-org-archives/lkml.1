Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbYBSAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbYBSAua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYBSAuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:50:22 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:34698 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYBSAuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:50:20 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu
Subject: Re: inode leak in 2.6.24?
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu>
	<20080218215344.GM155407@sgi.com>
Date: Tue, 19 Feb 2008 01:50:14 +0100
In-Reply-To: <20080218215344.GM155407@sgi.com> (David Chinner's message of
	"Tue, 19 Feb 2008 08:53:44 +1100")
Message-ID: <871w79hird.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Sat, Feb 16, 2008 at 12:18:58AM +0100, Ferenc Wagner wrote:
> 
>> 5 days ago I pulled the git tree (HEAD was
>> 25f666300625d894ebe04bac2b4b3aadb907c861), added two minor patches
>> (the vmsplice fix and the GFS1 exports), compiled and booted the
>> kernel.  Things are working OK, but I noticed that inode usage has
>> been steadily rising since then (see attached graph, unless lost in
>> transit).  The real filesystems used by the machine are XFS.  I wonder
>> if it may be some kind of bug and if yes, whether it has been fixed
>> already.  Feel free to ask for any missing information.
>
> Output of /proc/slabinfo, please. If you could get a sample when the
> machine has just booted, one at the typical post-boot steady state
> as well as one after it has increased well past normal, it would
> help identify what type of inode is increasing differently.

Ugh.  Your message came just a little bit too late, I rebooted the
machine a couple of hours ago for applying an IPv6 patch, without
saving /proc/slabinfo.  The currently running kernel is 2.6.24.2 +
GFS1 exports + IPv6 fix, and I snapshotted /proc/slabinfo approx. 3
hours after reboot.  At least we will see whether this version also
produces the problem, it isn't too different after all (for some
"too").

Btw. there was no steady-state with the previous kernel, the increase
started right after reboot, which means that by tomorrow I'll be able
to tell whether it's increasing again or this kernel doesn't exhibit
such effect.

> Also, can you tell us what metrics you are graphing (i.e. where
> in /proc or /sys you are getting them from)?

I wonder why I assumed everybody knows Munin's graphs by heart...
In short: "inode table size" is the first value from
/proc/sys/fs/inode-nr; "open inodes" is the same minus the second
value.  In other words:

awk '{print "used.value " $1-$2 "\nmax.value " $1}' < /proc/sys/fs/inode-nr

I'll come back shortly with the new findings.  If nothing turns up,
it's possible to boot up the previous kernel (or -- if needed --
current git) with this IPv6 fix added and check that again.
-- 
Thanks,
Feri.
