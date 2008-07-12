Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYGLAut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYGLAut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYGLAuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:50:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbYGLAuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:50:40 -0400
Date: Fri, 11 Jul 2008 17:50:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: smfrench@gmail.com, niallain@gmail.com, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] [CIFS] fix inode leak in cifs_get_inode_info_unix
Message-Id: <20080711175015.a96d18f7.akpm@linux-foundation.org>
In-Reply-To: <20080702095734.31936.79354.stgit@dantu.usersys.redhat.com>
References: <20080702095734.31936.79354.stgit@dantu.usersys.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 05:57:38 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> Date: 	Wed, 02 Jul 2008 05:57:38 -0400

hm, nine days and afaict this post-2.6.25 regression remains unfixed?

> Sender: linux-kernel-owner@vger.kernel.org
> User-Agent: StGIT/0.14.2
> 
> Try this:
> 
>     mount a share with unix extensions
>     create a file on it
>     umount the share
> 
> You'll get the following message in the ring buffer:
> 
> VFS: Busy inodes after unmount of cifs. Self-destruct in 5 seconds.  Have a
> nice day...
> 
> ...the problem is that cifs_get_inode_info_unix is creating and hashing
> a new inode even when it's going to return error anyway. The first
> lookup when creating a file returns an error so we end up leaking this
> inode before we do the actual create. This appears to be a regression
> caused by commit 0e4bbde94fdc33f5b3d793166b21bf768ca3e098.
> 
> The following patch seems to fix it for me, and fixes a minor
> formatting nit as well.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

So it's probably too late to get this into 2.6.26.  I'll merge it with
a cc:stable and hopefully 2.6.26.1 will not have this bug.

I'll give "fix wksidarr declaration to be big-endian friendly" the same
treatment.

