Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYFMUUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYFMUUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 16:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYFMUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 16:19:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46369 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYFMUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 16:19:55 -0400
Date: Fri, 13 Jun 2008 13:19:46 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/3][BUGFIX] configfs: Introduce configfs_dirent_lock
Message-ID: <20080613201946.GC20576@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080612133126.335618468@kerlabs.com> <20080612134203.763166823@kerlabs.com> <20080612191348.GE5377@mail.oracle.com> <20080612222558.GA4012@localdomain> <20080613024130.GD20581@mail.oracle.com> <20080613104513.GI30804@localhost> <20080613120923.GJ30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613120923.GJ30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 02:09:23PM +0200, Louis Rilling wrote:
> Oh, should probably provide some d_revalidate() also, which would return
> -ENOENT for a dentry under a directory flagged with USET_DROPPING. But I'm
> realizing that such "inconsistencies" (some default groups being valid in the
> d_cache and some other ones not) already happen between the time detach_prep()
> has flagged a default group with USET_DROPPING and the default
> group is actually detached. Am I wrong?

	We don't need d_revalidate().  As I stated at the end of my last
email, USET_DROPPING does not mean 'It already went away'.  It just
means we're safe to do so, because we prevent new children.  We actually
make it go away underneath i_mutex.
	The VFS handles inconsistencies between lookup and action.  It's
part of normal operation.  Otherwise, they'd have to hold all the
i_mutexes around lookup and action.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
