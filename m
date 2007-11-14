Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbXKNVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbXKNVu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXKNVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:50:49 -0500
Received: from ozlabs.org ([203.10.76.45]:49459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbXKNVut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:50:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.28062.309910.416774@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 08:50:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.040758.101673950.davem@davemloft.net>
References: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
	<20071114.035236.84619893.davem@davemloft.net>
	<18234.58380.400222.329961@cargo.ozlabs.ibm.com>
	<20071114.040758.101673950.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> > You're suggesting that the behaviour of a read() should depend on what
> > was in the buffer before the read?  Gack!  Surely you have better
> > taste than that?
> 
> Absolutely that's what I mean, it's atomic and gives you exactly what
> you need.
> 
> I see nothing wrong or gross with these semantics.  Nothing in the
> "book of UNIX" specifies that for a device or special file the passed
> in buffer cannot contain input control data.

Ohhhhh.... kayyyyy.... *shudders*

It really violates the abstract model of "read" pretty badly.  "Read"
is "fill in the buffer with data from the device", not "do some
arbitrary stuff with this area of memory".

I'd prefer to have a transaction() system call like I suggested to
Nick rather than overloading read() like this.

> > Then you end up with two system calls to get the data rather than one
> > (one to send the request and another to read the reply).  For
> > something that needs to be quick that is a suboptimal interface.
> 
> Not necessarily, consider the possibility of using recvmsg() control
> message data.  With that it could be done in one go.
> 
> This also suggests that it could be implemented as it's own protocol
> family.

There's all sorts of possible ways that it could be implemented.  On
the one hand we have an actual proposed implementation, and on the
other we have various people saying "oh but it could be implemented
this other way" without providing any actual code.

Now if those people can show that their way of doing it is
significantly simpler and better than the existing implementation,
then that's useful.  I really don't think that doing a whole new
net protocol family is a simpler and better way of doing a performance
monitor interface, though.

Paul.
