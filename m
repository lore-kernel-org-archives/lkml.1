Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbXCTUCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbXCTUCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXCTUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:02:10 -0400
Received: from ozlabs.org ([203.10.76.45]:41318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbXCTUCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:02:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17919.42767.233797.860230@cargo.ozlabs.ibm.com>
Date: Tue, 20 Mar 2007 20:19:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: jesse.barnes@intel.com, zaitcev@redhat.com, jg@laptop.org,
       linux-kernel@vger.kernel.org
Subject: Re: BSOD
In-Reply-To: <20070319.130544.115907938.davem@davemloft.net>
References: <20070319120807.af36ef5d.zaitcev@redhat.com>
	<20070319.123836.39155546.davem@davemloft.net>
	<200703191254.36373.jesse.barnes@intel.com>
	<20070319.130544.115907938.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> Mode setting is complex and it is not going to work exactly when you
> need the kernel crash message the most.

It's a matter of writing maybe a dozen MMIO registers on the ATI
chips, for instance, with some delays.  Provided we have interrupts
disabled and udelay still works, there's not a lot of the kernel that
we need to rely on to do that.

> After debugging the kernel for 10+ years I can tell you one thing, for
> a bad crash what's going to happen is you'll get the printk but that's
> about all that will work at that point, and the kernel is going to
> hang next.  Sometimes you won't get the whole panic message, just
> the beginning, even with the most simplistic printk implementation.
> 
> You will not, I repeat, will not be able to mode switch or anything
> non-trivial like that when the kernel is in this state.
> 
> Mode switching on panic, just say no. :-)

Anything is better than nothing.  At the moment we get nothing if you
are in X when the panic occurs, even for the nicest, most well-behaved
panics. :)  If we can change that to getting something sometimes,
that's a win.

Paul.
