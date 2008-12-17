Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753295AbYLQVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYLQVft (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLQVfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:35:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbYLQVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:35:21 -0500
Date: Wed, 17 Dec 2008 13:34:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, alex.zeffertt@eu.citrix.com,
        Ian.Campbell@citrix.com
Subject: Re: [PATCH UPDATED] xen: add xenfs to allow usermode <-> Xen
 interaction
Message-Id: <20081217133429.b64e6421.akpm@linux-foundation.org>
In-Reply-To: <49496E17.2010703@goop.org>
References: <49480F39.2010102@goop.org>
	<20081216125425.30524946.akpm@linux-foundation.org>
	<49496E17.2010703@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 13:24:39 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The xenfs filesystem exports various interfaces to usermode.  Initially
> this exports a file to allow usermode to interact with xenbus/xenstore.
> 
> Traditionally this appeared in /proc/xen.  Rather than extending procfs,
> this patch adds a backward-compat mountpoint on /proc/xen, and provides
> a xenfs filesystem which can be mounted there.
> 
> [ 
>   I did quite a lot of work to this code as a result of review, which is
>   why this is a repost rather than a delta.  The changes are:
> 
>    - Moved the XENFS_SUPER_MAGIC to linux/magic.h
>    - Added comments to answer the "what's this for?" questions (I hope)
>    - Split things out into smaller functions
>    - Cleaned up type of queue_reply(), removed casts
>    - Added a mutex to protect struct xenbus_file_priv.  This protects
>       the list heads, and the partial message buffer.  There were
>       several ways in which usermode could overwrite the kernel's
>       memory via races without this locking.
>    - Fixed a bug in which usermode could start sending a message
>       which can never be sent, leaving the file descriptor in a
>       useless state.

I'm bored of your filesystem, so I think I'll just merge it, unless
someone else wants to ;)


Was this noticed and considered?

WARNING: consider using strict_strtoul in preference to simple_strtoul
#543: FILE: drivers/xen/xenfs/xenbus.c:315:
+               trans->handle.id = simple_strtoul(reply, NULL, 0);

total: 0 errors, 1 warnings, 781 lines checked

