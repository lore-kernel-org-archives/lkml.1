Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbXFTWzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbXFTWzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXFTWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:55:21 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:58464 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXFTWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:55:20 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
References: <467994BD.6000403@zytor.com>
From: Nix <nix@esperi.org.uk>
Emacs: is that a Lisp interpreter in your editor, or are you just happy to see me?
Date: Wed, 20 Jun 2007 23:55:15 +0100
In-Reply-To: <467994BD.6000403@zytor.com> (H. Peter Anvin's message of "Wed, 20 Jun 2007 13:57:33 -0700")
Message-ID: <87abuu2q3w.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jun 2007, H. Peter Anvin verbalised:

> Right now it is actually impossible to conclusively determine a
> filesystem-relative path in the presence of bind (and possibly move)
> mounts.  This is highly desirable to be able to do in contexts that
> involve non-Linux (or not-the-current-instance-of-Linux) accesses to the
> filesystem, e.g. other filesystems or bootloaders.

It's also highly desirable if you want to be able to run a backup :) one
would desire to back up the filesystem as a whole, not some bind mount
of one directory out of it (and backing up both is needless
duplication).

So I applaud this and would be an immediate user, no matter what format
is chosen, as long as we can tell what is mounted where.

(As an aside, it would be nice if mount(8) could supply (a limited
amount of) extra (arbitrary?) textual options to the kernelq,
specifically so that mount options which are only interpreted by
userspace programs, like `user' and the quota options, could appear in
/proc/mounts. That way we could finally ditch bloody /etc/mtab for good.

(Any other approach requires mount(8) to keep track of these options in
a separate file, which brings back exactly the same synchronization
horrors that we're all so nauseatingly familiar with from /etc/mtab.)

> I'm personally leaning toward the second option (/dev/md6:/users/foo).
> Although that might confuse current utilities, those utilities are
> *already* liable to get confused by the fact that the line doesn't mean
> what they think it means.

Quite so. The output from df(8) in the presence of large numbers of bind
mounts was ludicrous before it started explicitly ignoring filesystems
of type `none', and that was arguably the wrong place to fix it.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
