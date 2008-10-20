Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYJTVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYJTVeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYJTVeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:34:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:37705 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYJTVeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:34:06 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20081020113602.GA2697@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
	 <20081020113143.GB14097@elte.hu>  <20081020113602.GA2697@elte.hu>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:33:35 +1100
Message-Id: <1224538415.7654.160.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 13:36 +0200, Ingo Molnar wrote:
> got rid of the brackets, see the patches below.
> 
> One open question would be whether to set the width to 8 on 32-bit 
> platforms and 16 on 64-bit platforms - right now it's 8 on both. Since 
> this is specifically a 'physical address' thing it might make sense to 
> extend that on 64-bit systems. (although it's quite a bit of screen real 
> estate so i think the current width of 8 should be fine)

A -lot- of 64-bit platforms (though not all of them) have most of their
stuff still in the 32 bit space, especially when IO is concerned.
Keeping it to 8 thus makes the output nicer on those, and as Linus
mentioned before, it's not like we lose digits anyway.

If you want, you can re-use the #ifdef/#define I did for resources and
thus give archs the option to have a different default.

Cheers,
Ben.


