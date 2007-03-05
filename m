Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXCEE13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXCEE13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXCEE13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:27:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:55085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbXCEE12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:27:28 -0500
Date: Mon, 5 Mar 2007 05:27:24 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070305042724.GB19783@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <20070304.201142.41654149.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070304.201142.41654149.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 08:11:42PM -0800, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Fri, 23 Feb 2007 16:37:43 +0100
> 
> > So I introduce a new method for resizing hash tables with RCU, and apply
> > that to the dentry hash.
> 
> Thanks for doing this work Nick.  I'm going to take your ideas
> and apply them to an ipv4 routing cache dynamic growth patch I
> worked on a while ago.

Sounds great, I would be happy to help review it. If we can create a
bit of common infrastructure, the dcache conversion might become a bit
more palatable and we could look at other things like the inode hash
as well.

> One minor nit:
> 
> > +struct dentry_hash {
> > +	unsigned int shift;
> > +	unsigned long mask;
> > +	struct hlist_head *table;
> > +};
> 
> I don't see any reason to make 'mask' an unsigned long
> and this makes this structure take up 8 bytes more than
> necessary on 64-bit.

You're right, the mask is currently just an int, so my patch should
not be messing with that. Thanks.

The other thing you'll have to be careful of when looking at doing
an implementation, is that I think I forgot to use the RCU accessors
(rcu_assign_pointer, rcu_dereference) when assigning and loading
the new/old hash table pointers.

