Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbYETVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbYETVqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbYETVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:46:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42844 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755858AbYETVqm (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:46:42 -0400
Date: Wed, 21 May 2008 07:46:17 +1000
From: David Chinner <dgc@sgi.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520214617.GU103491721@sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520065622.GA13968@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:56:23AM +0400, Evgeniy Polyakov wrote:
> On Tue, May 20, 2008 at 10:25:03AM +1000, David Chinner (dgc@sgi.com) wrote:
> > +	filemap_fdatawrite_range(mapping, start, end);
> > 
> > Where [start,end] span page->index and are is large enough
> > to get a substantial sized I/O to disk (say at least SWAP_CLUSTER_MAX
> > pages, preferrably larger for 4k page size machines).
> 
> Or just sync_inode().

Oh, god no. Let's not put the inode_lock right at the top of
the VM page cleaning path. We don't need to modify inode state,
the superblock dirty lists, etc - all we need to do is write
dirty pages on a given mapping in a more efficient manner.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
