Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbXLCPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbXLCPL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXLCPLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:11:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35579 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXLCPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:11:48 -0500
Date: Mon, 3 Dec 2007 15:11:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Lord <lord@xfs.org>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071203151141.GB18082@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com> <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:36:25PM -0600, Stephen Lord wrote:
> Wow, was it really that long ago!
>
> Looks like the readdir is in the bowels of the btree code when filldir gets 
> called
> here, there are probably locks on several buffers in the btree at this 
> point. This
> will only show up for large directories I bet.

Chris saw it with block-form directories.  I've verified it works fine
with short-form directories, and the leaf code looks like it could
happen aswell.  I also remember gfs2 running into a similar problem.

> The xfs readdir code has the complete xfs inode number in its hands at this 
> point
> (filldir is not necessarily getting all the bits of it). All we are doing 
> the lookup
> for really is to get the inode number back again so we can get the inode
> and get the attributes. Rather dumb really. There has got to be a way of
> doing a callout structure here so that the inode number can be pushed
> through filldir and back into an fs specific call. The fs then can do a 
> lookup
> by id - which is what it does most of the time for resolving nfs handles
> anyway. Should be more efficient than the current scheme.

Yes, a lot more efficient.  But it means adding a new operation for use
by the nfs server.

