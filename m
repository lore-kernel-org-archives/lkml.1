Return-Path: <linux-kernel-owner+w=401wt.eu-S935919AbXHHAzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935919AbXHHAzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbXHHAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:55:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756932AbXHHAzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:55:25 -0400
Date: Tue, 7 Aug 2007 17:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       zippel@linux-m68k.org, dhowells@redhat.com,
       linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu,
       joel.becker@oracle.com, linux-ext4@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com,
       user-mode-linux-user@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com,
       jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       xfs@oss.sgi.com
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070807175402.03ceb0b7.akpm@linux-foundation.org>
In-Reply-To: <1186533934.6625.91.camel@heimdal.trondhjem.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 20:45:34 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> 
> If you really need to know that the filesystem is handling the flags,
> then how about instead having ->setattr() return something which
> indicates which flags it actually handled? That is likely to be a far
> more intrusive change, but it is one which is future-proof.

If we change ->setattr so that it will return a positive, non-zero value
which the caller can then check and reliably do printk("that filesystem
needs updating") then that addresses my concern, sure.
