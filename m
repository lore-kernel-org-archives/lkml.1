Return-Path: <linux-kernel-owner+w=401wt.eu-S936971AbXHLR4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936971AbXHLR4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbXHLR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:56:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762AbXHLR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:56:34 -0400
Date: Sun, 12 Aug 2007 10:56:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
In-Reply-To: <200708121159.40211.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0708121051140.30176@woody.linux-foundation.org>
References: <20070812081252.GA23309@vana.vc.cvut.cz>
 <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
 <200708121159.40211.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Andi Kleen wrote:
> 
> Can you please just apply the patch series please? 
> This one is fixed in  "Make patching more robust, fix paravirt issue"

I *had* applied the patch series, Andi. And that one will do

	memcpy(addr, opcode, len);

even though "addr" itself may be all of memcpy().

So the code was buggy, and Petr fixed it, and your patch-series didn't fix 
*anything*. In fact, from what I can tell, it's the one that introduced 
the problem, because before thatone hit, we'd always do the two-byte 
sequence on its own (since the "nop_out()" on the rest of the memcpy would 
be called later, and separately, once it didn't matter any more).

So out of 12 patches, 2 caused machines to not even boot. Not good.

			Linus
