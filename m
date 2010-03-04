Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0CDLvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:51:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55218 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0CDLvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:51:05 -0500
To: Sage Weil <sage@newdream.net>
CC: hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.1003031324310.20129@cobra.newdream.net> (message
	from Sage Weil on Wed, 3 Mar 2010 13:37:43 -0800 (PST))
Subject: Re: [PATCH 23/26] ceph: nfs re-export support
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
 <1267577217-31923-24-git-send-email-sage@newdream.net> <20100303074814.GA1030@infradead.org> <Pine.LNX.4.64.1003031324310.20129@cobra.newdream.net>
Message-Id: <E1Nn9Zu-0005dZ-LC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Mar 2010 12:50:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Sage Weil wrote:
> On Wed, 3 Mar 2010, Christoph Hellwig wrote:
> > On Tue, Mar 02, 2010 at 04:46:54PM -0800, Sage Weil wrote:
> > > Basic NFS re-export support is included.  This mostly works.  However,
> > > Ceph's MDS design precludes the ability to generate a (small)
> > > filehandle that will be valid forever, so this is of limited utility.
> > 
> > So don't include it if it's broken by design.
> 
> Well, there are changes we can make to the MDS to make it work that are on 
> the roadmap (they'll also help with disaster recovery).  They will require 
> some change on the client side, though, so it's not like the current 
> implementation will suddenly work perfectly with a server-side upgrade.
> 
> That said, I don't think Ceph is the only filesystem that has this problem 
> (fat? fuse? cifs?), and it is still useful in its current state.  But I 
> can leave it off by default (via Kconfig option), or include a kern.log 
> warning, or leave it out entirely, if that's what people prefer.

Fuse uses a fixed 64bit handle on the userspace/kernel API and on the
"low level" userspace API, so that's NFS export compatible.

On the "high level" API fuse uses path strings, which are not so
suitable for NFS exporting.  Despite that, people have been exporting
these fuse filesystems over NFS and dealing with the occasional ESTALE
if the inode has been evicted from the cache on the server side but
the client still holds a file handle.

CIFS doesn't seem to have any export capability.  FAT tries, but is
also not guaranteed to work if the inodes are no longer in the cache.

Thanks,
Miklos
