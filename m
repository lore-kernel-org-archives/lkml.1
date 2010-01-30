Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395Ab0A3KsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0A3KsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 05:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265Ab0A3KsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 05:48:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0A3KsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 05:48:14 -0500
Date: Sat, 30 Jan 2010 11:48:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: Slab Fragmentation Reduction V15
Message-ID: <20100130104812.GE29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129204931.789743493@quilx.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:31PM -0600, Christoph Lameter wrote:
> This patchset was first proposed in the beginning of 2007. It was almost merged
> in 2008 when last minute objections arose in the way this interacts with
> filesystem objects (inode/dentry).
> 
> Andi has asked that we reconsider this issue. So I have updated the patchset

Thanks for reposting.

My motivation here is to improve hwpoison soft offlining, but I think
having this would be a general improvement.

> to apply against current upstream (and also -next with a special patch
> at the end). The issues with icache/dentry locking remain. In order
> for this to be merged we would have to come up with a revised dentry/inode
> locking code that can
> 
> 	1. Establish a reference to an dentry/inode so that it is pinned.
>            Hopefully in a way that is not too expensive (i.e. no superblock
>            lock)
> 
> 	2. A means to free a dentry/inode objects from the VM reclaim context.


Al, do you have a suggestions on a good way to do that?

I guess the problem could be simplified by ignoring dentries in "unusual"
states?

> The other objection against this patchset was that it does not support
> reclaim through SLAB. It is possible to add this type of support to SLAB too

I think not supporting SLAB/SLOB is fine.

-Andi
