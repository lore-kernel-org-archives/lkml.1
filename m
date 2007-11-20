Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXKTWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXKTWj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbXKTWjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:39:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:60801 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758634AbXKTWjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:39:44 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <1195593015.17601.10.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop> <20071120082927.GA8856@alpha.franken.de>
	 <1195569362.3131.3.camel@localhost.localdomain> <adaabp8wuma.fsf@cisco.com>
	 <1195593015.17601.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 09:39:03 +1100
Message-Id: <1195598343.6970.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-20 at 15:10 -0600, James Bottomley wrote:
> We're talking about trying to fix this for 2.4; which is already at
> -rc3 ... Is an entire arch change for dma alignment really a merge
> candidate at this stage?

Well, as I said before... it's a matter of what seems to be the less
likely to break something right ?

On one side,  I'm doing surgery on code I barely know, the scsi error
handling, and now it seems I also have to fixup a handful of drivers
that aren't the most obvious pieces of code around.

On the other side, Roland proposal is basically just adding a macro that
can be empty for everybody but a handful of archs, and stick it onto one
field in one structure...

The later has about 0 chances to actually break something or cause a
regression. I wouldn't say that about the former.

Now, I will see if I manage to fixup the NCR drivers to pass a
pre-allocated buffer (USB storage I think can pass NULL as it's not
calling prep in atomic context). But then, it complicates the matter
because that means "restore" will have to know whether prep allocated
the buffer or not, thus more fields to add to the save struct, it's
getting messy, unless we decide -all- callers are responsible for the
buffer allocation (hrm... maybe the best approach).

Ben.


