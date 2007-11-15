Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXKOCeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXKOCeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 21:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXKOCea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 21:34:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXKOCe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 21:34:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.45103.397753.321892@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 13:34:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.172722.71465976.davem@davemloft.net>
References: <18235.32982.439970.359975@cargo.ozlabs.ibm.com>
	<20071114.152134.266510129.davem@davemloft.net>
	<18235.40110.831730.847548@cargo.ozlabs.ibm.com>
	<20071114.172722.71465976.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> From: Paul Mackerras <paulus@samba.org>
> Date: Thu, 15 Nov 2007 12:11:10 +1100
> 
> > The third (hard to extend cleanly) is a good point, and is a valid
> > criticism of the current set of perfmon2 system calls, I think.
> > However, the goal of being able to extend the interface tends to be in
> > opposition to the goal of having strong typing of the interface.
> > Things like a multiplexed syscall or an ioctl are much easier to
> > extend but that is at the expense of losing strong typing.
> 
> I disagree.
> 
> With netlink we can just add new attributes when a new need arises for
> a particular interface.  The attribute code describes the type
> precisely, so there is no loss of strong typing at all.

Well you must mean something different by "strong typing" from the
rest of us.  Strong typing means that the compiler can check that you
have passed in the correct types of arguments, but the compiler
doesn't have any visibility into what structures are valid in netlink
messages.

In any case, I think that adding a structure size argument to the
current perfmon2 system calls where appropriate would mean that we
could extend them cleanly later on if necessary.  It would mean that
we could add fields at the end, and that the kernel could know what
version of the structures that userspace was using.

Paul.
