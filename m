Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbXHHFP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbXHHFP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXHHFPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:15:45 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:51457 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbXHHFPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:15:43 -0400
To: akpm@linux-foundation.org
CC: jlayton@redhat.com, codalist@telemann.coda.cs.cmu.edu,
       cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, reiserfs-devel@vger.kernel.org,
       zippel@linux-m68k.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, joel.becker@oracle.com, dhowells@redhat.com,
       fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
       user-mode-linux-user@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
       ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
In-reply-to: <20070807171501.e31c4a97.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 7 Aug 2007 17:15:01 -0700)
Subject: Re: [fuse-devel] [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com> <20070807171501.e31c4a97.akpm@linux-foundation.org>
Message-Id: <E1IIdsT-0001dn-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 08 Aug 2007 07:14:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >From a purely practical standpoint: it's a concern that all filesytems need
> patching to continue to correctly function after this change.  There might
> be filesystems which you missed, and there are out-of-tree filesystems
> which won't be updated.
> 
> And I think the impact upon the out-of-tree filesystems would be fairly
> severe: they quietly and subtly get their secutiry guarantees broken (I
> think?)
> 
> Is there any way in which we can prevent these problems?  Say
> 
> - rename something so that unconverted filesystems will reliably fail to
>   compile?

Maybe renaming ATTR_MODE to ATTR_MODE_SET (changing it's value as
well, so that binary stuff breaks visibly as well)?

This would make sense, because we are changing what this attribute
acually means.  In the new code attr->ia_mode only contains the
originally set mode, not the ones we've added to change the suid bits.

Miklos
