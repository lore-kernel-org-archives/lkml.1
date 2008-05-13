Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYEMJWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYEMJWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYEMJWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:22:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYEMJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:22:01 -0400
Date: Tue, 13 May 2008 05:21:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net, Donald Douwsma <donaldd@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: [Jfs-discussion] Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513092156.GA26736@infradead.org>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org> <20080513090311.GZ155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513090311.GZ155679365@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 07:03:11PM +1000, David Chinner wrote:
> Sure - XFS will start another three kernel threads per filesystem
> that gets mounted. And for good measure, it cleans them up again
> on unmount. :)
> 
> The other threads are per-cpu workqueue threads that are shared
> across all XFS filesystems in the system and hence are started
> when XFS is initialised rather than when a mount occurs.

Well, we could refcount the number of active xfs instances and
start/stop the global threads based on that.  Not really worth my
time IHMO, but if someone comes up with a clean enough patch it should
go in.
