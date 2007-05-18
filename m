Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXERX2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXERX2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXERX2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:28:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:56296 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbXERX2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:28:47 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Dave Liu <r63238@freescale.com>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <464DAD06.2060504@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
	 <464CB071.5050504@ru.mvista.com>
	 <9095839480a9686d9c40aa6143edb804@kernel.crashing.org>
	 <464CB460.40905@ru.mvista.com>
	 <97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org>
	 <1179464690.32247.370.camel@localhost.localdomain>
	 <1179466769.3658.0.camel@localhost.localdomain>
	 <1179472096.32247.394.camel@localhost.localdomain>
	 <464DAD06.2060504@ru.mvista.com>
Content-Type: text/plain
Date: Sat, 19 May 2007 09:27:52 +1000
Message-Id: <1179530872.32247.423.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 17:41 +0400, Sergei Shtylyov wrote:
>     From the "PowerPC Operating Environment Architecture" that I've
> already 
> quoated t follows that POWER4-compatible decremented exception *must*
> be edge 
> triggered.
> 
> > says that an exception is generated when the MSB transitions from 0
> to
> > 1. It's not clear wether the exception sticks while that bit is 1 or
> is
> 
>     Freescale MPC 7450 manual says the same, for example. 

I find it extremely silly to implement it as edge anyway. The EE line is
level triggered, and having a mix of edge and level on the same
exception without a clean way to retrigger the DEC one other than
waiting one tick is just causing trouble.

Ben.


