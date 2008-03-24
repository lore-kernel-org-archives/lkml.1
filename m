Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYCXJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYCXJxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYCXJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 05:53:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42806 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYCXJxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 05:53:09 -0400
Date: Mon, 24 Mar 2008 09:53:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080324095300.GI10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk> <1206348614.2961.21.camel@ram.us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206348614.2961.21.camel@ram.us.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 01:50:14AM -0700, Ram Pai wrote:
> > Is there any reason why we do that in ->umount_begin() and not *after*
> > it, unconditionally, straight from do_umount()?  AFAICS, the only reason
> > why it's done from fs-specific code is figuring out which mount-list
> > should the stuff go back to, and that's both broken *and* not needed
> > with sanitized locking as above.  While we are at it, I'd rather return
> > ->umount_begin() to its previous prototype, TYVM - the less filesystem
> > sees vfsmounts, the better off we all are...
> 
> I think that ->umount_begin also acts a hook for providing pre-umount
> event notification to userspace from filesystems; something that is
> required by DMAPI interface.

"Why, so can I, and so can any man..."

IOW, DMAPI might require whatever its authors want it to require, but
what does that have to do with us?

BTW, I've dropped several more patches into the tree (sanitizing
namespace.c/pnode.c) and merged that into mountinfo-base.  Documentation
is mostly done, so it will be the next thing to go there, then it's
time for 'dissolve unreachable subtrees on d_invalidate()' stuff.
Which probably will mean *another* cyclic list in vfsmount, not anchored
but pointed to by replacement of d_mounted; same protection as for
mnt_child/mnt_mounts, contains vfsmounts with given mnt_mountpoint.
I'm not too fond of that, but I don't see cleaner way to do it at the
moment.  Any better ideas are welcome...
