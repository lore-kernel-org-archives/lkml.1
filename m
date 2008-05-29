Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYE2Vvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYE2Vvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbYE2Vu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:50:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50749 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294AbYE2Vu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:50:56 -0400
Date: Thu, 29 May 2008 14:48:28 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jes Sorensen <jes@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       scottwood@freescale.com, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <1212097223.8888.55.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0805291442420.18832@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>  <20080526.184047.88207142.davem@davemloft.net>
  <1211854540.3286.42.camel@pasglop>  <20080526.192812.184590464.davem@davemloft.net>
  <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
  <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop> 
 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net>
 <1212097223.8888.55.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Benjamin Herrenschmidt wrote:
> On Thu, 2008-05-29 at 10:47 -0400, Jes Sorensen wrote:
> Interesting. I've always been taught by ia64 people that mmiowb() was
> intended to be used solely between writel() and spin_unlock().

That's what I gathered too, based on what's written in memory-barriers.txt,
which is the only kernel docs I could find that addressed this.

> Yes, this has some cost (can be fairly significant on powerpc too) but
> I think it's a very basic assumption from drivers that consecutive
> writel's, especially issued by the same CPU, will get to the device
> in order.

It's also what memory-barriers.txt says they should do.

> If this is a performance problem, then provide relaxed variants and
> use them in selected drivers.

I wrote a JTAG over gpio driver for the powerpc MPC8572DS platform.  With the
non-raw io accessors, the JTAG clock can run at almost ~9.5 MHz.  Using raw
versions (which I had to write since powerpc doesn't have any), the clock
speed increases to about 28 MHz.  So it can make a very significant different.
