Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYJNVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYJNVEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYJNVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:04:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55520 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYJNVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:04:45 -0400
To: matt.craighead@conifersystems.com
CC: miklos@szeredi.hu, tj@kernel.org, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <2cff7cb50810141032m5793a405h7425dfa122fb67ba@mail.gmail.com>
	(matt.craighead@conifersystems.com)
Subject: Re: [fuse-devel] [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	 <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <2cff7cb50810141032m5793a405h7425dfa122fb67ba@mail.gmail.com>
Message-Id: <E1Kpr47-0000lw-Fk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Oct 2008 23:04:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Matt Craighead wrote:
> > The other is that I really
> > really don't want people to start implementing new custom ioctls for
> > their filesystems, as I think that way lies madness.
> 
> Do you have a proposed alternative for file systems that need complex
> non-standard file system operations?  I think the suggestion on the web site
> was to use get/setxattr.  I tried that and found two problems:
> 
> 1. there's no bidirectional version that both sends arguments to the
> operation and receives more than just a status back in a single API call --
> you can get, you can set, but you can't set and get extra info back
> 2. xattr's are limited in size by the kernel; large ones get truncated

Another alternative is to use some sort of out-of-band communication
with the server (socket, shared memory, etc).  Doesn't suffer from
either of the above issues and does not have the limitations and
implementation problems (having to access another process's address
space directly) of ioctls.

OTOH if you can solve it with standard file operations within the same
namespace as the regular files, that's the best solution.  Like you
said you get network transparency, and you also let normal tools
operate on the special control files, which can be a very powerful
thing (think scripting).  You'd never get that with ioctls, and that's
one of the reasons why ioctls suck.

Miklos
