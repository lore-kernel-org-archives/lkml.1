Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbYD0Wq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbYD0Wq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYD0WqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:46:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36269
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYD0WqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:46:21 -0400
Date: Sun, 27 Apr 2008 15:46:20 -0700 (PDT)
Message-Id: <20080427.154620.177583216.davem@davemloft.net>
To: jeff@garzik.org
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4815009C.2010809@garzik.org>
References: <20080427214837.GA11631@elte.hu>
	<1209335660.3801.79.camel@localhost.localdomain>
	<4815009C.2010809@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 27 Apr 2008 18:39:24 -0400

> I disagree with this semantics change.  A number of code places _and 
> drivers_ GET IT RIGHT, and these are all broken now?

[ Note, James's patch that you quoted is about mapping DMA
  memory, in dma_declare_coherent_memory(), rather than devices.
  But I know what you are trying to talk about Jeff. :-) ]

Wrt. ioremap() semanics, it is important to realize that if
the implementation of this on x86 has been giving non-cached
I/O mappings out up until recently, you can expect that there
are hundreds of drivers that might now be broken.

That's the sad fact of the ubiquity of x86, and it doesn't matter how
we defined the API is some document.

Anyways, my point is that this angle should be strongly considered in
any discussion about ioremap() behavior.

