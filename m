Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbZAUOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbZAUOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZAUOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:55:18 -0500
Received: from thunk.org ([69.25.196.29]:43579 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZAUOzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:55:15 -0500
Date: Wed, 21 Jan 2009 09:55:13 -0500
From: Theodore Tso <tytso@mit.edu>
To: Victor Pelt <victor.pelt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 no space left
Message-ID: <20090121145513.GH31253@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Victor Pelt <victor.pelt@gmail.com>, linux-kernel@vger.kernel.org
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 03:19:28PM +0100, Victor Pelt wrote:
> Hey,
> 
> i tried to switch my root partition to ext4 (from reiserfs) but i ran
> into problems when copying over all the data that it says 'no space
> left on the device'
> i'm running 2.6.28-gentoo-r1 (based on 2.6.28.1 if i'm not mistaken)
> 
> rootfs                 5044188   4310972    476980  91% /  <= file
> system that is 'full'
>
> i like to use that last 470MB if possible
> 
> fsck didn't help (tried that)

If this is the problem I think it is, it's fixed in patches that were
merged for 2.6.29 (in -rc1), and you can work around it via umounting
and remounting the filesystem (or in case of the root filesystem,
rebooting).

However, when you said "fsck didn't help", what exactly did you mean
by that?  That fsck didn't show any problems, when you ran it while
the filesystem was mounted?  Did you actually reboot and force an
fsck, and then found that you were still getting ENOSPC errors?

I assume you have tried writing as root, and that quotas are disabled?

  	     	  		   	 - Ted

P.S.  If it is the problem I think it is, upgrading 2.6.29-rcX should
fix the problem, as would using the ext4-stable branch in the ext4 git
tree, or applying the patches in the for-stable branch of the ext4 git
tree:

    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
