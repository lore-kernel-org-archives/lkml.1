Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZFXX7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZFXX7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFXX6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:58:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53502 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZFXX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:58:54 -0400
Date: Thu, 25 Jun 2009 00:58:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not
	mounted
Message-ID: <20090624235856.GZ8633@ZenIV.linux.org.uk>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:00:56AM +0200, Denys Vlasenko wrote:
> More elegant way is to execute /proc/self/exe.
> This works just fine as long as /proc is mounted.

So mount it.

> But it breaks if /proc isn't mounted, and this can happen in real-world
> usage. For example, when shell invoked very early in initrd/initramfs.

So mount it.

> With this patch, it is possible to execute /proc/self/exe
> even if /proc is not mounted.

> How patch does it: when execve syscall discovers that opening of binary
> image fails, a small bit of code is added to special case "/proc/self/exe"
> string. If binary name is *exactly* that string, and if error is ENOENT
> or EACCES, then exec will still succeed, using current binary's image.
> 
> Please apply.

No.  This is just plain sick.  Magical pathnames have no business being
in the kernel.  If procfs is too much for your sensitive soul, do an
extremely trimmed-down version that would consist of *one* *file* (yes,
as root and only node on fs).  Said file being a procfs-style symlink,
doing exactly what /proc/self/exec would do.

On such system you can just mkdir /proc/self, touch /proc/self/exec,
mount -t self_exec none /proc/self/exec and be done with that.  No
magic needed, end of the story.
