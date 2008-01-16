Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYAPDwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYAPDwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYAPDwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:52:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47706 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbYAPDwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:52:32 -0500
Date: Wed, 16 Jan 2008 03:52:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Gabor Gombas <gombasg@sztaki.hu>, Greg KH <greg@kroah.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in sysfs_rename/move_dir()
Message-ID: <20080116035224.GW27894@ZenIV.linux.org.uk>
References: <478D74A6.7000206@gmail.com> <478D75BD.1010805@gmail.com> <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 07:41:58PM -0800, Linus Torvalds wrote:

> and wonder what happen sif old_parent == new_parent. Is that trying to 
> avoid an ABBA deadlock? Normally you'd do it by ordering the locks, or by 
> taking a third lock to guarantee serialization at a higher level (ie the 
> "s_vfs_rename_mutex" on the VFS layer)
> 
> I'd like to apply these two patches, but I really want to get more of an 
> ack for them from somebody like Al, or at least more of an explanation for 
> why it's all the right thing.

No ACK is coming until we get something resembling analysis of locking
scheme.  Which won't happen until we at least get the "what callers are
allowed to do" written down, damnit.  As it is, I'm more than inclined
to propose ripping kobject_move() out, especially since it has only two
users - something s390-specific and rfcomm, with its shitloads of problems
beyond just sysfs interaction.
