Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXHKC6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXHKC6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 22:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761054AbXHKC6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 22:58:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458AbXHKC6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 22:58:05 -0400
Date: Sat, 11 Aug 2007 03:57:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into individual setattr functions (RESEND)
Message-ID: <20070811025739.GA21244@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org,
	dhowells@redhat.com, linux-cifs-client@lists.samba.org,
	codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com,
	linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net,
	cluster-devel@redhat.com,
	user-mode-linux-user@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
	jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org,
	bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com> <20070807171501.e31c4a97.akpm@linux-foundation.org> <1186533934.6625.91.camel@heimdal.trondhjem.org> <20070810164752.23117e0e.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810164752.23117e0e.jlayton@redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:47:52PM -0400, Jeff Layton wrote:
> attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
> bit is set then BUG(). The helper function already clears those bits
> so anything using it should automatically be ok. We'd have to fix
> up NFS and a few others that don't implement suid/sgid.
> 
> This is not as certain as changing the name of the inode operation. It
> would only pop when someone is attempting to change a setuid/setgid
> file on these filesystems. Still, it should conceivably catch most if
> not all offenders. Would that be sufficient to take care of everyone's
> concerns?

I like the idea of checking ia_valid after return a lot.  But instead of
going BUG() it should just do the default action, that we can avoid
touching all the filesystem and only need to change those that need
special care.  I also have plans to add some new AT_ flags for implementing
some filesystem ioctl in generic code that would benefit greatly from
the ia_valid checkin after return to return ENOTTY fr filesystems not
implementing those ioctls.
