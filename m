Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYFBVyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYFBVyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYFBVyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:54:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:46423 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYFBVyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:54:32 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <20080602103643.GA21285@elte.hu>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <1211859542.3286.46.camel@pasglop>
	 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805271028520.2958@woody.linux-foundation.org>
	 <20080602103643.GA21285@elte.hu>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 07:53:24 +1000
Message-Id: <1212443604.26672.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 12:36 +0200, Ingo Molnar wrote:
> The patch passed initial light testing in -tip (~30 successful random 
> self-builds and bootups on various mixed 32-bit/64-bit boxes) but
> it's 
> still v2.6.27 material IMO.

I think adding the "memory" clobber should be .26 and even -stable. We
know for sure newer gcc will re-order things, we know it for sure some
drivers will break in subtle ways because of that, ad we know as well
that sticking "memory" clobber in there will fix that breakage we know
about ... So I don't see the point of waiting.

Ben.


