Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYJTVgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYJTVgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYJTVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:35:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:47514 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYJTVf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:35:57 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-pci@vger.kernel.org, yhlu.kernel@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1224507486.27899.31.camel@johannes.berg>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
	 <2008102  <20081020113602.GA2697@elte.hu>
	 <1224507486.27899.31.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:35:18 +1100
Message-Id: <1224538518.7654.164.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 14:58 +0200, Johannes Berg wrote:
> On Mon, 2008-10-20 at 13:36 +0200, Ingo Molnar wrote:
> 
> > +	/* room for the actual number, the "0x" and the final zero */
> > +	char sym[2*sizeof(phys_addr_t) + 2];
> 
> Buffer overflow.

It's actually not going to overflow as we pass the end of the buffer to
"number" but we'll miss a digit.

Ben.


