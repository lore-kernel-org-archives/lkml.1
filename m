Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYJZN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYJZN0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYJZN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:26:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYJZN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:26:07 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Hugh Dickins <hugh@veritas.com>, Rob MacKinnon <c4blem0nkey@gmail.com>
Subject: Re: tmpfs support of xattrs?
Date: Sun, 26 Oct 2008 14:25:58 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
References: <4902DD98.4090302@gmail.com> <Pine.LNX.4.64.0810261148480.14974@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0810261148480.14974@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261425.58892.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 October 2008 13:26:35 Hugh Dickins wrote:
> On Sat, 25 Oct 2008, Rob MacKinnon wrote:
> > The background: So during the initial configuration of a box I enabled
> > the xattr flags for ext3 and options of xattr in coreutils, and at the
> > time didn't realize that I'd hit a snag that would finally annoy me
> > enough after a month of getting a non-fatal error messages from cp "cp:
> > listing attributes of `/dev/null`: Invalid argument" to spend half a day
> > researching the cause and a potential solution.
> >
> > Setup: udev mounts a tmpfs to /dev then fills it with device nodes.
> > Problem: the resulting tmpfs has no xattr support.
> > Therefore: Tmpfs without xattrs, and coreutils  and everywhere else with
> > xattr support, cp freaks.
> >
> > Is there sometime in the forseable future when the tmpfs module will
> > support for xattrs in the stable branch, or should I "holler at the
> > maintainers of coreutils to fix their broken code in cp". Even better
> > (and I like this option the most) a little of both?
>
> I've not seen "cp: listing attributes of `/dev/null': Invalid argument"
> messages (or.. do I have a dim recollection of them once upon a time?).
> I would certainly get irritated by them if I did, and want to fix them.
> I tried "cp /dev/null temp" on a few distros just now but not seen it.

As Hugh pointed out already, tmpfs does support xattrs since quite a while, so 
enabling that should fix the symptoms. Independent of that, cp must of course 
work correctly on filesystems that don't have xattrs. Those filesystems are 
not supposed to return EINVAL, though.

Could you please run cp under strace to show us what's happening at the 
syscall level (and perhaps under ltrace in addition to see the library level 
as well)?

If the error happens at the syscall level (*listxattr), then which kernel is 
it exactly, and where can I find its sources?

Thanks,
Andreas
