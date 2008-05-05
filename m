Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYEENIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYEENIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYEENIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:08:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYEENII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:08:08 -0400
Date: Mon, 5 May 2008 09:08:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       menage@google.com
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
Message-ID: <20080505130804.GA1809@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org> <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:32:22PM +0200, Miklos Szeredi wrote:
> > Looks correct but I don't think it's a good idea.  Spreading more logic
> > into filesystems without a good reason is rarely a good idea.
> 
> (Thanks for the review, Christoph)
> 
> Agreed completely, but vfs_* aren't for filesystems to call, rather
> for entities calling _into_ filesystems from the outside.  This is
> actually a very rare thing, so adding some extra logic for the sake of
> cleanliness should be OK.
> 
> Now it can be argued, that cgroup_clone() is calling into the
> filesystem from the outside.  But it's not really doing that, rather
> it's making an internal modification to a specific filesystem,
> triggered by some external action.

I don't think that matters. We're not about overly strict layering, and
especialy this kind where you call into a higher layer to get back into
the lower one is not harmful at all.  For cgroup it's only a small
duplication, but e.g. I don't really like all the duplications in the
reiserfs case.  Unless we have a very good reason why the useage of the
vfs_ function should go away from the filesystem code I don't think
we want this.
