Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYE0Vj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYE0Vj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbYE0Vjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:39:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:41988 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbYE0Vjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:39:48 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <1211859542.3286.46.camel@pasglop>
	 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	 <1211922621.3286.80.camel@pasglop>
	 <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 07:38:55 +1000
Message-Id: <1211924335.3286.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So practically speaking, I suspect that the right approach is to just say 
> "ok, x86 will continue to be pretty darn ordered, and the barriers won't 
> really matter (*)" but at the same time also saying "we wish reality was 
> different, and well-maintained drivers should probably try to work in the 
> presense of re-ordering".

Ok, well, I'll slap "memory" clobbers onto powerpc accessors, we made
them fully ordered a while ago anyway. The extra barriers in drivers
like USB etc.. won't hurt us much, we can always fine tune drivers that
really want high performances.

A problem with __raw_ though is that they -also- don't do byteswap,
which is a pain in the neck as people use them for either one reason
(relaxed ordering) or the other (no byteswap) without always knowing the
consequences of doing so...

I'm happy to say that __raw is purely about ordering and make them
byteswap on powerpc tho (ie, make them little endian like the non-raw
counterpart).

Some archs started providing writel_be etc... I added those to powerpc a
little while ago, and I tend to prefer that approach for the byteswap
issue.

What do you think ?

Ben.


