Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYE0RcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYE0RcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYE0RcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:32:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbYE0RcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:32:04 -0400
Date: Tue, 27 May 2008 10:31:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805271028520.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>  <20080526.184047.88207142.davem@davemloft.net>  <1211854540.3286.42.camel@pasglop>  <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Linus Torvalds wrote:
> 
> Here's a UNTESTED patch for x86 that may or may not compile and work, and 
> which serializes (on a compiler level) the IO accesses against regular 
> memory accesses.

Ok, so it at least boots on x86-32. Thus probably on x86-64 too (since the 
code is now shared). I didn't look at whether it generates much bigger 
code due to the potential extra serialization, but some of the code 
generation I looked at looked fine.

IOW, it doesn't at least create any _obviously_ worse code, and it should 
be arguably safer than assuming the compiler does volatile accesses the 
way we want it to.

		Linus
