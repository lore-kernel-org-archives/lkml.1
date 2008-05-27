Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYE0VNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYE0VNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYE0VNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:13:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:35136 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbYE0VNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:13:09 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <1211859542.3286.46.camel@pasglop>
	 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 07:12:46 +1000
Message-Id: <1211922766.3286.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 09:47 -0700, Linus Torvalds wrote:
> 
> __read[bwlq]()/__write[bwlq]() are not serialized with a :"memory" 
> barrier, although since they still use "asm volatile" I suspect that
> i 
> practice they are probably serial too. Did not look very closely at
> any 
> generated code (only did a trivial test to see that the code looks 
> *roughly* correct).

Nah, asm volatile doesn't help, it does need the "memory" clobber too.

Cheers,
Ben.


