Return-Path: <linux-kernel-owner+w=401wt.eu-S1764637AbXHWTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbXHWTbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbXHWTb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:31:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52011 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXHWTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:31:26 -0400
Date: Thu, 23 Aug 2007 20:31:21 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Renumber AUDIT_TTY_[GS]ET
Message-ID: <20070823193121.GM21089@ftp.linux.org.uk>
References: <20070823091953.GK21089@ftp.linux.org.uk> <20070823073241.2c470cb5@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823073241.2c470cb5@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 07:32:41AM -0700, Arjan van de Ven wrote:
> On Thu, 23 Aug 2007 10:19:53 +0100
> Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > From: Miloslav Trmac <mitr@redhat.com>
> > 
> > Renumber AUDIT_TTY_[GS]ET to avoid a conflict with netlink message
> > types already used in the wild.
> 
> which are these? Were they in mainline or -mm before?
> 
> also, if this is so sensitive, at least add something that says to never ever use 1014/1015...

AUDIT_TTY_*ET went into mainline directly and I'd missed the conflict with
the numbers already in use by audit-subtree patches.  I *had* noticed when
pushing audit-subtree to -mm, swore at myself and renumbered those.  Alas,
there's userland to deal with.
	* auditctl has subtree support merged
	* auditctl still doesn't have tty... support merged
	* it's built with numbers matching the original patchset (1014/1015)
and binaries are released
	* audit-subtree patchset is in RH beta kernel, also released

Vote of auditctl maintainer had been "renumber tty_...* until it's too late,
since that's the one userland doesn't support yet".  The author of tty patches
agrees (see above) and I also think that this is the best way out of that mess.

Again, it's largely my fault - I'd missed the conflict in the first place and
hadn't reacted immediately.
