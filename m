Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXH0V03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXH0V03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760337AbXH0VUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:20:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40259
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbXH0VU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:20:28 -0400
Date: Mon, 27 Aug 2007 14:20:17 -0700 (PDT)
Message-Id: <20070827.142017.48523835.davem@davemloft.net>
To: grundler@parisc-linux.org
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, parisc-linux@parisc-linux.org,
       clameter@sgi.com
Subject: Re: [parisc-linux] [patch 15/23] Add cmpxchg_local to parisc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070827210432.GA22484@colo.lackof.org>
References: <20070812145434.520271946@polymtl.ca>
	<20070812145840.691277845@polymtl.ca>
	<20070827210432.GA22484@colo.lackof.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@parisc-linux.org>
Date: Mon, 27 Aug 2007 15:04:32 -0600

> Doesn't explain the difference between "local" and "non-local" either.
> Per CPU data should only need memory barriers (in some cases) and
> protection against interrupts (in probably more cases). So I'm not
> understanding why a new set of APIs is needed.
> 
> Can you add a description to Documentation/atomic_ops.txt ?

My understanding is that the local versions can run without
memory barriers.  Only local cpu execution and local interrupt
threads of control can access the variable, and interrupts
force all stores to become visible to the local cpu so an
interrupt can't see the datum from before the atomic update
if one was in progress when the interrupt triggered, and
stuff like that.
