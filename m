Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbYD0Wxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbYD0Wxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYD0Wxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:53:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39058 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYD0Wxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:53:45 -0400
Message-ID: <481503ED.8060107@garzik.org>
Date: Sun, 27 Apr 2008 18:53:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: James.Bottomley@HansenPartnership.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net>
In-Reply-To: <20080427.154620.177583216.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Sun, 27 Apr 2008 18:39:24 -0400
> 
>> I disagree with this semantics change.  A number of code places _and 
>> drivers_ GET IT RIGHT, and these are all broken now?
> 
> [ Note, James's patch that you quoted is about mapping DMA
>   memory, in dma_declare_coherent_memory(), rather than devices.
>   But I know what you are trying to talk about Jeff. :-) ]
> 
> Wrt. ioremap() semanics, it is important to realize that if
> the implementation of this on x86 has been giving non-cached
> I/O mappings out up until recently, you can expect that there
> are hundreds of drivers that might now be broken.
> 
> That's the sad fact of the ubiquity of x86, and it doesn't matter how
> we defined the API is some document.
> 
> Anyways, my point is that this angle should be strongly considered in
> any discussion about ioremap() behavior.

Understood.

I guess I am more annoyed that this stealth semantics change appears to 
have broken everything that depends on pci_iomap(), including 90%+ of 
all libata drivers, unless I am missing something.

That one piece of code (pci_iomap) was correct under the old semantics, 
on x86 and elsewhere.  It's tested and working nicely, and depended upon 
by many drivers.

	Jeff



