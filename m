Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0BARym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:54:42 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40034 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0BARyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:54:41 -0500
Date: Mon, 1 Feb 2010 11:53:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Rik van Riel <riel@redhat.com>
cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: Slab Fragmentation Reduction V15
In-Reply-To: <4B6447EC.7030702@redhat.com>
Message-ID: <alpine.DEB.2.00.1002011152510.30861@router.home>
References: <20100129204931.789743493@quilx.com> <20100130104812.GE29555@one.firstfloor.org> <4B6447EC.7030702@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010, Rik van Riel wrote:

> On 01/30/2010 05:48 AM, Andi Kleen wrote:
> > On Fri, Jan 29, 2010 at 02:49:31PM -0600, Christoph Lameter wrote:
>
> > > 	1. Establish a reference to an dentry/inode so that it is pinned.
> > >             Hopefully in a way that is not too expensive (i.e. no
> > > superblock
> > >             lock)
> > >
> > > 	2. A means to free a dentry/inode objects from the VM reclaim context.
> >
> >
> > Al, do you have a suggestions on a good way to do that?
>
> You cannot free inode objects for files that are open, mmapped, etc.

Of course. Those objects need to prevent reclaim attempts.

> > I guess the problem could be simplified by ignoring dentries in "unusual"
> > states?
>
> You mean dentries that are in use? :)

The existing patch already tried to discern that and avoid the reclaim of
these.

