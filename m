Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXEWPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXEWPha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbXEWPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:37:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49989 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbXEWPhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:37:19 -0400
Date: Wed, 23 May 2007 16:37:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523153718.GB4095@ftp.linux.org.uk>
References: <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk> <20070523121620.GU4095@ftp.linux.org.uk> <E1HqqTC-00023W-00@dorka.pomaz.szeredi.hu> <20070523135140.GW4095@ftp.linux.org.uk> <E1HqrtF-0002Fb-00@dorka.pomaz.szeredi.hu> <20070523150602.GZ4095@ftp.linux.org.uk> <E1Hqsij-000338-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hqsij-000338-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 05:25:49PM +0200, Miklos Szeredi wrote:
> > > How will this work with copy_tree() and namespace duplication, which
> > > currently walk the tree with only namespace_sem held?
> > 
> > Easy - grab namespace_sem, grab vfsmount_lock, walk the subtree and bump
> > mnt_busy on everything (by 1 + number of non-busy children).  Then drop
> > vfsmount_lock and do as usual, dropping references in tree being copied
> > as you go.  Nothing will get attached or detached due to namespace_sem,
> > nothing will get evicted by anybody other than you since you've got all
> > that stuff pinned down.  End of story...
> 
> Right.
> 
> Do you have some code?
> 
> Should I try to code something up?

I hope to get some breathing space next week, then I'll get back to
VFS work.  I'd rather do that one myself, since it'll be a long series
of equivalent transformations - debugging such rewrite of refcounting
done as a single patch is going to be hell.  And yes, refcounting rewrite
is near the top of the list (another thing is wading through several
threads from hell and reviewing unionfs ;-/)
