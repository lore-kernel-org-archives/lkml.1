Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZFHFKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZFHFKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZFHFKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:10:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbZFHFKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:10:35 -0400
Date: Sun, 7 Jun 2009 22:08:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - remove hashed check in validate_wait()
Message-Id: <20090607220814.cc7519f6.akpm@linux-foundation.org>
In-Reply-To: <20090608032537.7088.1870.stgit@zeus.themaw.net>
References: <20090608032537.7088.1870.stgit@zeus.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009 11:25:37 +0800 Ian Kent <raven@themaw.net> wrote:

> The recent ->lookup() deadlock correction required the directory
> inode mutex to be dropped while waiting for expire completion. We
> were concerned about side effects from this change and one has
> been identified.
> 
> When checking if a mount has already completed prior to adding a
> new mount request to the wait queue we check if the dentry is hashed
> and, if so, if it is a mount point. But, if a mount successfully
> completed while we slept on the wait queue mutex the dentry must
> exist for the mount to have completed so the test is not really
> needed.
> 
> Mounts can also be done on top of a global root dentry, so for the
> above case, where a mount request completes and the wait queue entry
> has already been removed, the hashed test returning false can cause
> an incorrect callback to the daemon. Also, d_mountpoint() is not
> sufficient to check if a mount has completed for the multi-mount
> case when we don't have a real mount at the base of the tree.
> 

I've been scratching my head trying to work out if this is a
needed-in-2.6.30 fix, but all I got was a bald spot.  Help?
