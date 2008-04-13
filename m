Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYDMDeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYDMDeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 23:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYDMDdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 23:33:55 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:60160 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYDMDdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 23:33:54 -0400
Date: Sat, 12 Apr 2008 23:33:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413033344.GA27494@hash.localnet>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412170304.54f139e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 05:03:04PM -0700, Andrew Morton wrote:
> Adding a new FS to Linux is a pretty major thing.
> 
> - A key question (which you don't seem to have addressed at all!) is: why
>   is this a useful addition to Linux?  What are the filesystem's strengths?
>   What is its application?  How does it improves Linux and by how much?

Honestly, I'm not sure if this FS is mainline material or not.  If it is, 
it is in the sense that the Amiga FS, befs, and so forth are useful:
it's a dead filesystem that a very few people still have a reason to
use.  If FUSE is where this should live, then I'll just simply focus my
time on that instead (since I already have it in FUSE).

Primarily the users are Rio Karma owners such as myself.  For some reason
the designers stuck this filesystem on the device, so unless someone hacks 
the firmware, using OMFS is the only way to get MP3 files on the thing 
from Linux.  Just so happens the same company made ReplayTV.

>   I'll go aehad and assume that its sweet-spot is streaming media files
>   (perhaps more than one at a time?).  If so, then comparative performance
>   measurements would be the key piece of information which we'll need when
>   making a merge decision.  Probably against ext3, ext4 and XFS.

Okay.  I can do benchmarks but I'm pretty sure it will be worse than all 
of them by a long shot.  

Note my Kconfig text:
[...]
+	  player and ReplayTV DVR.  Despite the name, this filesystem is not
+	  more efficient than a standard FS for MPEG files, in fact likely
+	  the opposite is true.  

Uncached lookups in particular are very slow because directories are 
essentially a huge hash table.  You might have to seek through several 
siblings in a bucket to get to the target file.

They seem to have designed for online recovery with checksumming and
mirroring of every FS object.  This module updates these, but it does
not do any online checking/repair.  I have written an mkfs/fsck, though.

> - We'd like to see some documentation:

Gotcha.

> Who did the reverse-engineering, and how was it done?
> Please make us confident that we won't get our butts sued off or something.

I'm not sure there's a company to sue anymore.

Most of it was done by members of the ReplayTV community; I just used
their documentation.  I'll see if I can get in touch with one of them to 
see how they came up with that.  I only figured out a few things, for 
which I'd use the Karma as a black box for copying/deleting files etc. 
and then poke at the resulting disk image with a hex editor.

-- 
Bob Copeland %% www.bobcopeland.com 

