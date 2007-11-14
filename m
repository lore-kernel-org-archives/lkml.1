Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbXKNMIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbXKNMIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXKNMIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:08:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbXKNMID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:08:03 -0500
Date: Wed, 14 Nov 2007 04:07:58 -0800 (PST)
Message-Id: <20071114.040758.101673950.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <18234.58380.400222.329961@cargo.ozlabs.ibm.com>
References: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
	<20071114.035236.84619893.davem@davemloft.net>
	<18234.58380.400222.329961@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Wed, 14 Nov 2007 23:03:24 +1100

> You're suggesting that the behaviour of a read() should depend on what
> was in the buffer before the read?  Gack!  Surely you have better
> taste than that?

Absolutely that's what I mean, it's atomic and gives you exactly what
you need.

I see nothing wrong or gross with these semantics.  Nothing in the
"book of UNIX" specifies that for a device or special file the passed
in buffer cannot contain input control data.

> > Another alternative is to use generic netlink.
> 
> Then you end up with two system calls to get the data rather than one
> (one to send the request and another to read the reply).  For
> something that needs to be quick that is a suboptimal interface.

Not necessarily, consider the possibility of using recvmsg() control
message data.  With that it could be done in one go.

This also suggests that it could be implemented as it's own protocol
family.
