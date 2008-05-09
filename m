Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYEIVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYEIVH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYEIVHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:07:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48896 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754015AbYEIVHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:07:14 -0400
Date: Fri, 9 May 2008 16:07:13 -0500
From: Russ Anderson <rja@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v3
Message-ID: <20080509210713.GA21370@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080509151135.GD16523@sgi.com> <Pine.LNX.4.64.0805091358160.20375@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805091358160.20375@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 02:03:19PM -0700, Christoph Lameter wrote:
> On Fri, 9 May 2008, Russ Anderson wrote:
> 
> > +	local_irq_save(irq_flags);
> 
> The page migration functions expect to be called in non atomic contexts 
> since they use things like lock_page(). Can you just drop the irq disable? 

Yes.

> The spinlock should not be there either. Page migration serialize via 
> the LRU. Pages that are to be migrated have to be taken off the LRU 
> first. There is no danger of two threads trying to migrate the same 
> page because the second one will not be able to take it off the LRU 
> anymore.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
