Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYB1Eke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYB1Eke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYB1EkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:40:24 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYB1EkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:40:23 -0500
Date: Wed, 27 Feb 2008 20:40:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/4] autofs4 - autofs needs a miscelaneous device for
 ioctls
Message-Id: <20080227204002.49f4c5fb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 12:21:58 +0900 (WST) Ian Kent <raven@themaw.net> wrote:

> 
> Hi Andrew,
> 
> There is a problem with active restarts in autofs (that is to
> say restarting autofs when there are busy mounts).
> 
> Currently autofs uses "umount -l" to clear active mounts at
> restart. While using lazy umount works for most cases, anything
> that needs to walk back up the mount tree to construct a path,
> such as getcwd(2) and the proc file system /proc/<pid>/cwd, no
> longer works because the point from which the path is constructed
> has been detached from the mount tree.
> 
> The actual problem with autofs is that it can't reconnect to
> existing mounts. Immediately one things of just adding the
> ability to remount autofs file systems would solve it, but
> alas, that can't work. This is because autofs direct mounts
> and the implementation of "on demand mount and expire" of
> nested mount trees have the file system mounted on top of
> the mount trigger dentry.
> 
> To resolve this a miscellaneous device node for routing ioctl
> commands to these mount points has been implemented for the
> autofs4 kernel module.
> 
> For those wishing to test this out an updated user space daemon
> is needed. Checking out and building from the git repo or
> applying all the current patches to the 5.0.3 tar distribution
> will do the trick. This is all available at the usual location
> on kernel.org.
> 

Could we please be a bit more specific than "the usual location"?

Should autofs userspace have an entry in Documentation/Changes?
