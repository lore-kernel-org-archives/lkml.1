Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYBFJvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYBFJvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbYBFJuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:50:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758515AbYBFJux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:50:53 -0500
Date: Wed, 6 Feb 2008 01:51:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Clem Taylor" <clem.taylor@gmail.com>
Cc: linux-kernel@vger.kernel.org, Amy Griffis <amy.griffis@hp.com>
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch
 descriptor leak?]
Message-Id: <20080206015103.9a0f4069.akpm@linux-foundation.org>
In-Reply-To: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 20:49:42 -0500 "Clem Taylor" <clem.taylor@gmail.com> wrote:

> I'm trying to move a MIPS based embedded system from 2.6.16.16 to
> 2.6.24. Most things seem to be working, but I'm having troubles with
> inotify. The code is using inotify to detect a file written to /tmp
> (tmpfs). The writer creates a file with a temporary name and then
> rename()s the tmp file over the file I'm monitoring.
> 
> With 2.6.16.16, everything works fine, but with 2.6.24, the inotify
> process runs for a while (~100 events) and then inotify_add_watch()
> returns ENOSPC. Once this happens, I can't add new watches, even if I
> kill the process and restart it. fs.inotify.max_user_instances and
> fs.inotify.max_user_watches are both 128, so I'd imagine I'm hitting
> this limit. For some reason the watches aren't getting cleaned up
> (even after the process is killed).
> 
> In a loop, the code is doing:
>     wd = inotify_add_watch(fd, file, IN_CLOSE_WRITE|IN_DELETE_SELF|IN_ONESHOT);
>     blocking read on notify fd
> 
> Has something changed in the inotify() API since 2.6.16.16, or could
> this be a leak?
> 

Good bug report, thanks.  That code was significantly altered in June 2006
and perhaps something broke.

It's a bit hard to find people who work on inotify, I'm afraid.  If you had
the time to come up with a script or program which demonstrates the bug,
that would be super-helpful?
