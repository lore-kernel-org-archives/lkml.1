Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYE2WHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYE2WHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYE2WHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:07:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:54941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbYE2WHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:07:41 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: Jes Sorensen <jes@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       scottwood@freescale.com, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
In-Reply-To: <Pine.LNX.4.64.0805291442420.18832@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>
	 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net>
	 <1212097223.8888.55.camel@pasglop>
	 <Pine.LNX.4.64.0805291442420.18832@t2.domain.actdsltmp>
Content-Type: text/plain
Date: Fri, 30 May 2008 08:05:39 +1000
Message-Id: <1212098739.8888.58.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 14:48 -0700, Trent Piepho wrote:

> I wrote a JTAG over gpio driver for the powerpc MPC8572DS platform.  With the
> non-raw io accessors, the JTAG clock can run at almost ~9.5 MHz.  Using raw
> versions (which I had to write since powerpc doesn't have any), the clock
> speed increases to about 28 MHz.  So it can make a very significant different.

Yes, sync's can hurt a lot. This is why I initially tried to get more
relaxed semantics.

We could implement something like __ variants and do something that
would still have eieio's but not sync's for example (ie. MMIOs are still
ordered vs. each other but not vs. coherent memory).

Ben.


