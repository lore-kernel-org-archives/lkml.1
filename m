Return-Path: <linux-kernel-owner+w=401wt.eu-S934657AbYETW0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657AbYETW0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765127AbYETW0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:26:04 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58927 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764748AbYETW0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:26:01 -0400
Date: Wed, 21 May 2008 02:25:05 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520222505.GA23988@2ka.mipt.ru>
References: <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520214617.GU103491721@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:46:17AM +1000, David Chinner (dgc@sgi.com) wrote:
> Oh, god no. Let's not put the inode_lock right at the top of
> the VM page cleaning path. We don't need to modify inode state,
> the superblock dirty lists, etc - all we need to do is write
> dirty pages on a given mapping in a more efficient manner.

I'm not advocating that, but having swap on reclaim does not hurt
anyone, this is essentially the same, but with different underlying
storage. System will do that anyway sooner or later during usual
writeback, which in turn can be a result of the same reclaim...

-- 
	Evgeniy Polyakov
