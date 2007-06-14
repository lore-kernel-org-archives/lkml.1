Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbXFNMNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbXFNMNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXFNMNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:13:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:55874 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbXFNMNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:13:38 -0400
Date: Thu, 14 Jun 2007 14:26:39 +0200
From: Jan Kara <jack@suse.cz>
To: holzheu <holzheu@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070614122639.GI13141@duck.suse.cz>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <20070614094128.GF17819@atrey.karlin.mff.cuni.cz> <1181817533.10064.18.camel@localhost.localdomain> <1181821661.10064.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181821661.10064.27.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-06-07 13:47:41, holzheu wrote:
> On Thu, 2007-06-14 at 12:38 +0200, holzheu wrote:
> > On Thu, 2007-06-14 at 11:41 +0200, Jan Kara wrote:
> > >   <snip>
> > > 
> > > > Your proposal is similar to one I made to some Japanese developers
> > > > earlier this year.  I was more modest, proposing that we
> > > > 
> > > > - add an enhanced printk
> > > > 
> > > > 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
> > >   Maybe a stupid idea but why do we want to assign these numbers by hand?
> > > I can imagine it could introduce collisions when merging tons of patches
> > > with new messages... Wouldn't it be better to compute say, 8-byte hash
> > > from the message and use it as it's identifier? We could do this
> > > automagically at compile time.
> > 
> > Of course automatically generated message numbers would be great and
> > something like:
> > 
> > hub.4a5bcd77: Detected some problem.
> 
> Sorry, I first read: 8 characters not 8 bytes.
> 
> Indeed, "hub.d41d8cd98f00b204: Detected some problem." ... does not look
> like very beautiful.
> 
> But maybe also 4 bytes would be enough, since the hash only has to be
> unique within one component e.g. "hub".
  It depends how large components you expect. For example for 10000
messages there is already 1% probability of collision so it means sooner or
later we are going to hit it... For 1000 messages the probability is
roughly 0.1% which is still not so small that I'd be comfortable with it.
On the other hand we could use something like gperf to generate perfect
hashing function and then we don't have to worry about colisions.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
