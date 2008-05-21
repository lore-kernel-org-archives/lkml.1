Return-Path: <linux-kernel-owner+w=401wt.eu-S935845AbYEUU3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935845AbYEUU3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbYEUU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:29:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41535 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761128AbYEUU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:29:17 -0400
Date: Wed, 21 May 2008 21:29:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/14] vfs: pass dentry to permission()
Message-ID: <20080521202914.GP28946@ZenIV.linux.org.uk>
References: <20080521171458.077908538@szeredi.hu> <20080521171551.453155765@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521171551.453155765@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:15:05PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The following patches clean up the i_op->permission() method and the
> related VFS API.
> 
> Here's an overview of the changes:
> 
>  - ->permission() is passed a dentry instead of an inode
>  - ->permission() is passed a integer flags parameter instead of a
>    nameidata pointer

No.  Take a good look at the instances.

	a) only one aberrant case cares about dentry, and for extremely
wrong reasons.  /proc/sys/ stuff.  ecryptfs, of course, will be happy
with any variant.
	b) few flags that are looked at are trivially mapped to new MAY_...

I have a patch series that does it, but it involves tons of fixing the
sysctl handling to be finished ;-/  And yes, we need sysctl to quit
doing the "I want to get ctl_table entry, so I'll do very painful search
by dentry every damn time" in any case - look at that code, it's far
too ugly to live.

IOW, consider this ->permission() API change NAKed.
