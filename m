Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYEWJcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYEWJcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYEWJce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:32:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbYEWJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:32:34 -0400
Date: Fri, 23 May 2008 05:32:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 04/14] gfs2: dont call permission()
Message-ID: <20080523093231.GA11963@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu> <1211533926.3635.552.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211533926.3635.552.camel@quoit>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 10:12:06AM +0100, Steven Whitehouse wrote:
> > I also suspect the conditional locking in gfs2_do_permission() could
> > be cleaned up, due to the removal of the implicit recursion.
> > 
> In order to be sure we'd have to check that there are no NFS code paths
> left which can reach this code. That has usually been the reason for
> conditional locking.
> 
> In general the patch looks ok to me, and since it doesn't appear to
> depend on anything else, I can drop it in my GFS2 git tree if that would
> be helpful at this stage,

The NFS ->lookup inside filldir recursion is still there, but I plan to
fix that for .27.  You'll be Cc'ed on that patch.

