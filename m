Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYE3Jgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYE3Jgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYE3Jg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:36:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbYE3Jg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:36:27 -0400
Message-ID: <483FCA94.1060506@sgi.com>
Date: Fri, 30 May 2008 11:36:20 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Roland Dreier <rdreier@cisco.com>, benh@kernel.crashing.org,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, Jeremy Higdon <jeremy@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>	 <20080526.184047.88207142.davem@davemloft.net>	 <1211854540.3286.42.camel@pasglop>	 <20080526.192812.184590464.davem@davemloft.net>	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>	 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net> <1212073289.3428.30.camel@localhost.localdomain>
In-Reply-To: <1212073289.3428.30.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> The only way to guarantee ordering in the above setup, is to either
>> make writel() fully ordered or adding the mmiowb()'s inbetween the two
>> writel's. On Altix you have to go and read from the PCI brige to
>> ensure all writes to it have been flushed, which is also what mmiowb()
>> is doing. If writel() was to guarantee this ordering, it would make
>> every writel() call extremely expensive :-(
> 
> So if a read from the bridge achieves the same effect, can't we just put
> one after the writes within the spinlock (an unrelaxed one).  That way
> this whole sequence will look like a well understood PCI posting flush
> rather than have to muck around with little understood (at least by most
> driver writers) io barriers?

Hmmm,

I think mmiowb() does some sort of status read from the bridge, I am not
sure if it's enough to just do a regular readl().

I'm adding Jeremy to the list, he should know for sure.

Cheers,
Jes

