Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbZDJJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbZDJJa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZDJJaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:30:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35475 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZDJJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:30:07 -0400
Date: Fri, 10 Apr 2009 10:28:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: yur@emcraft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] shmem: respect MAX_LFS_FILESIZE
In-Reply-To: <20090409163610.8619bfc7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0904101007200.2667@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
 <Pine.LNX.4.64.0904062155090.21044@blonde.anvils>
 <20090409163610.8619bfc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Andrew Morton wrote:
> On Mon, 6 Apr 2009 21:56:13 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Question: couldn't the 32-bit kernel's MAX_LFS_FILESIZE be almost doubled?
> > It limits the pagecache index to a signed long, but we use an unsigned long.
> 
> I expect it would be OK, yes.  The only failure mode I can think of is
> if someone is using signed long as a pagecache index and I'd be pretty
> surprised if we've made that mistake anywhere.  The potential for goofs
> is higher down in filesystems, but they shouldn't be using pagecache
> indices much at all.
> 
> Of course it does invite people to write applications which then fail
> on older kernels, but such is life.

Hmm, that's a very good point, and I doubt Ned Kelly can have the
last word on it.  Good filesystems go to a great deal of trouble over
the compatibility issues of new features: it would be rather sad to
blow that all away with a careless doubling of MAX_LFS_FILESIZE.

Or I'm talking nonsense: we already have this issue, when using
a 32-bit kernel to look at big files created with a 64-bit kernel.

But even so, I think I'll leave this change to someone braver.

Hugh
