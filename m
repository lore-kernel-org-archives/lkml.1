Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0CCR3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:29:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43980 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0CCR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:29:09 -0500
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1267567889-4637-1-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 2 Mar 2010 14:11:23 -0800)
Subject: Re: [RFC PATCH 0/6] Union mount core rewrite v1
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com>
Message-Id: <E1NmsNN-0003s9-P1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 03 Mar 2010 18:28:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Mar 2010, Valerie Aurora wrote:
> This is a major rewrite of parts of union mounts, in particular the
> pathname lookup code.  For more info about union mounts, see:
> 
> http://valerieaurora.org/union/
> 
> The previous code had two important problems fixed in this series:
> 
> - On file open, is_unionized() grabs vfsmount lock and walks up the
>   mount tree even for non-union mounts.
> 
> - Pathname lookup required three cut-n-pasted versions of two complex
>   functions, one for each of cached/real/"hashed" lookups.

Looks much better :)

> This rewrite reduces the additional cost of a non-union lookup in a
> CONFIG_UNION_MOUNT kernel to either 1 or 2 mount flag tests (but adds
> the requirement that file systems be unioned only at their root
> directories).  This rewrite implements lookup with one lookup_union()
> function for all types of lookups.
> 
> This posted patch series includes only the union lookup, mount, and
> readdir patches and not the relatively uncontroversial whiteout and
> fallthru code.

Special inode/dentry flags (whiteout, fallthrough, opaque) are not
trivially the right solution:

 - they are invisible from userspace, new APIs are necessary to manipulate them
 - they are difficult to support on network filesystems
 - they are not useful for anything other than union mounts/filesystems

Extended attributes are a more standard way to add such info to files.
Hard links would allow sharing a single inode for all whiteout entries
and one for all fallthrough entries.

Have these options been considered as an alternative?

Thanks,
Miklos
