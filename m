Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYABUZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYABUZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYABUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:25:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33141 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753714AbYABUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:25:06 -0500
Date: Wed, 2 Jan 2008 12:25:04 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
In-Reply-To: <20071228032645.GM27894@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0801021222250.20331@schroedinger.engr.sgi.com>
References: <20071226221631.GD27894@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
 <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com>
 <20071227235804.GJ27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271601200.1294@schroedinger.engr.sgi.com>
 <20071228004504.GK27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271811470.2053@schroedinger.engr.sgi.com>
 <20071228032645.GM27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Al Viro wrote:

> On Thu, Dec 27, 2007 at 06:19:46PM -0800, Christoph Lameter wrote:
> > nfsd4_delegations? What is this about?
> 
> The random lifetimes of user-visible files you create in sysfs.

Well these are symlinks.

> > How do I scan for the symlinks in sysfs?
> 
> At which point are you going to do that?  AFAICS, the fundamental problem
> is that you
> 	* have aliases indistinguishable, so kmem_cache_destroy() can't tell
> which one is going away, no matter what
> 	* have per-alias objects in sysfs
> As the result, you have a user-visible mess in that directory in sysfs.
> And I don't see how you would deal with that - on the "the contents of
> directory changes in so-and-so way when such-and-such operation is
> done", not the implementation details one.

If the alias count of a kmem_cache structure reaches zero then all aliases 
can be taken down. At that point we know that no aliases exist anymore.

> BTW, I'm rather sceptical about free use of slabs; keep in mind that their
> names have to be unique with your sysfs layout, so...

What do you mean by free use of slabs? Creation of new slab caches to 
avoid the rounding up to order 2 size?

