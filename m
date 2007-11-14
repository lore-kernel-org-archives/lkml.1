Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbXKNBgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbXKNBgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXKNBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:36:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60434
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbXKNBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:36:44 -0500
Date: Tue, 13 Nov 2007 17:36:43 -0800 (PST)
Message-Id: <20071113.173643.78069123.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com>
	<20071113.031510.151440585.davem@davemloft.net>
	<Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 14:20:02 -0800 (PST)

> On Tue, 13 Nov 2007, David Miller wrote:
> 
> > Yes, I could add virtualized area support to sparc64, but we cannot
> > impose this on every platform.
> 
> Other platforms do not have the 8MB restriction nor do they have so many 
> processors.

sparc32 has the same limitations, nobody is going to implement
the virt stuff there.

> Here is the draft of a virtual cpu area implementation for sparc64. Uses 
> the VMEMMAP chunks:

This doesn't avoid the core problem.  Bloating up the BSS like
that is bad, end enforcing a virt implementation to avoid that
is an anti-social way to go about implementing this feature.
