Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYAQEW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYAQEW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 23:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYAQEWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 23:22:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49625 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYAQEWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 23:22:19 -0500
Date: Thu, 17 Jan 2008 04:22:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gabor Gombas <gombasg@sztaki.hu>, Greg KH <greg@kroah.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in sysfs_rename/move_dir()
Message-ID: <20080117042216.GB27894@ZenIV.linux.org.uk>
References: <478D74A6.7000206@gmail.com> <478D75BD.1010805@gmail.com> <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org> <20080116035224.GW27894@ZenIV.linux.org.uk> <478DB0E1.7090401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478DB0E1.7090401@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 04:23:13PM +0900, Tejun Heo wrote:

> The two posted patches are bug fixes for apparent bugs which can be
> triggered by the current two users of the interface.  AFAICS, locking
> there is weird but correct for the current two users.  If you can find
> any problem there, please lemme know.

How about "what happens after that move-to-NULL if you have a cwd inside
the subtree", for starters?

>  We shouldn't hold this type of
> fixes for future clean ups.

No, but I'd rather see the rules for callers of sysfs/kobject primitives
spelled out - before cleanups or review become even possible.
 
> > As it is, I'm more than inclined
> > to propose ripping kobject_move() out, especially since it has only two
> > users - something s390-specific and rfcomm, with its shitloads of problems
> > beyond just sysfs interaction.
> 
> Can you please elaborate?  All sysfs problems discovered by the rfcomm
> are fixed by the posted patches.  Dave Young has a patch waiting for
> verification by the tester.

Umm...  IIRC, there'd been a lot of fun with tty and procfs sides of that;
will check.

> Furthermore, even if we rip out
> kobject_move() in the future, I don't think -rc7 is the right time to do it.

OK...  You do have a point, but at this stage I'm not convinced that this
thing is safe and usable.  I agree that patches do not make things worse,
but I suspect that the real problem with kobject_move() is that it's a
fundamentally broken interface.
