Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYJZM1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYJZM1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 08:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYJZM1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 08:27:15 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51054 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYJZM1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 08:27:14 -0400
Date: Sun, 26 Oct 2008 12:26:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Rob MacKinnon <c4blem0nkey@gmail.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: tmpfs support of xattrs?
In-Reply-To: <4902DD98.4090302@gmail.com>
Message-ID: <Pine.LNX.4.64.0810261148480.14974@blonde.site>
References: <4902DD98.4090302@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Rob MacKinnon wrote:

> The background: So during the initial configuration of a box I enabled
> the xattr flags for ext3 and options of xattr in coreutils, and at the
> time didn't realize that I'd hit a snag that would finally annoy me
> enough after a month of getting a non-fatal error messages from cp "cp:
> listing attributes of `/dev/null`: Invalid argument" to spend half a day
> researching the cause and a potential solution.
> 
> Setup: udev mounts a tmpfs to /dev then fills it with device nodes.
> Problem: the resulting tmpfs has no xattr support.
> Therefore: Tmpfs without xattrs, and coreutils  and everywhere else with
> xattr support, cp freaks.
> 
> Is there sometime in the forseable future when the tmpfs module will
> support for xattrs in the stable branch, or should I "holler at the
> maintainers of coreutils to fix their broken code in cp". Even better
> (and I like this option the most) a little of both?

I've not seen "cp: listing attributes of `/dev/null': Invalid argument"
messages (or.. do I have a dim recollection of them once upon a time?).
I would certainly get irritated by them if I did, and want to fix them.
I tried "cp /dev/null temp" on a few distros just now but not seen it.

I never paid much attention to xattrs myself, but my understanding was
that tmpfs has supported xattrs since 2.6.10: from 2.6.10 to 2.6.13
there was CONFIG_TMPFS_XATTR to enable it, then from 2.6.14 to 2.6.18
it was using generic security fallbacks, then from 2.6.19 onwards
using generic security fallbacks plus its own enabled by
CONFIG_TMPFS_POSIX_ACL.

There's probably various pieces of info we need from you: what distro?
what kernel? what coreutils? CONFIG_TMPFS_POSIX_ACL=y? CONFIG_SHMEM=y?
what does "attr -l /dev/null" say?

But I may well be missing the _right_ questions to ask: Cc'ed
Stephen who made the 2.6.14 changes and Andreas who made the
2.6.19 changes, they may jump to the answer immediately.

Hugh
