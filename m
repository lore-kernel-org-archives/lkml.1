Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZGORON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZGORON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZGORON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:14:13 -0400
Received: from claw.goop.org ([74.207.240.146]:60310 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbZGOROM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:14:12 -0400
Message-ID: <4A5E0E61.6020704@goop.org>
Date: Wed, 15 Jul 2009 10:14:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Chris Mason <chris.mason@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andrew Warfield <andy@cs.ubc.ca>,
       Jake Wires <Jake.Wires@citrix.com>,
       Daniel Stodden <Daniel.Stodden@citrix.com>
Subject: Using splice to carry Xen granted pages through the network stack?
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I originally sent this in March or so, but I don't think you
responded, and this still seems like an interesting idea. ]

Hi Jens,

In a thread from December last year ("Support for zero-copy TCP transmit
of user space data") you suggested using the splice machinery as a way
to implement zero-copy transmit for iscsi data.

I have a similar problem relating to doing zero-copy transmit of pages
granted from another Xen domain.  These are pages which are in some ways
similar to device mappings (they have no struct page unless we jump
through some hoops to give them one, for example) which are given to us
by another domain (virtual machine)'s network stack since they contain
data they want to transmit through our stack.  Once the stack has
finished with the pages we need to get them back to return to the
original domain (and definitely not let them get freed into the normal
kernel pool).

I've been looking a little bit at the splice stuff to work out how it
might be useful in this case.  One issue struct page; I guess we really
can't get away from having one for granted pages and still get the full
value of using splice (especially I can see also see it being useful on
the block side of the world as well).  So, we can jump through hoops for
that.

But the general plumbing of splice into the network stack seems to have
been an open issue since you introduced it 3 years ago (using as a
reference http://lwn.net/Articles/181169/).  Has any work been done on
this aspect since?  What would need to be done to do it?  Would it mean
wiring up a pipe_buffer_operations to operate with something like
Rusty's skb_shared_info destructor?

Thanks,
   J

