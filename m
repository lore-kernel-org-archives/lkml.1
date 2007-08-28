Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbXH1TxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbXH1TxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXH1TxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:53:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53567 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXH1TxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:53:01 -0400
Date: Tue, 28 Aug 2007 20:52:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>,
       linux-fsdevel@vger.kernel.org, nfs@lists.sourceforge.net,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 0/4] add killattr inode operation to allow filesystems to interpret ATTR_KILL_S*ID bits
Message-ID: <20070828195258.GA7332@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
	nfs@lists.sourceforge.net, linux-cifs-client@lists.samba.org,
	linux-kernel@vger.kernel.org
References: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com> <20070828191114.GA3419@infradead.org> <1188330591.6701.202.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188330591.6701.202.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 03:49:51PM -0400, Trond Myklebust wrote:
> Hmm... There has to be an implicit promise here that nobody else will
> ever try to set ATTR_KILL_SUID/ATTR_KILL_SGID and ATTR_MODE at the same
> time. Currently, that assumption is not there:
> 
> 
> > 	if (ia_valid & ATTR_KILL_SGID) {
> > 		attr->ia_valid &= ~ ATTR_KILL_SGID;
> > 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
> > 			if (!(ia_valid & ATTR_MODE)) {
> > 				ia_valid = attr->ia_valid |= ATTR_MODE;
> > 				attr->ia_mode = inode->i_mode;
> > 			}
> > 			attr->ia_mode &= ~S_ISGID;
> > 		}
> > 	}
> 
> Should we perhaps just convert the above 'if (!(ia_valid & ATTR_MODE))'
> into a 'BUG_ON(ia_valid & ATTR_MODE)'?

Yes, sounds fine to me.
