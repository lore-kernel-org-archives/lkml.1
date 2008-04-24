Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYDXBJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYDXBJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYDXBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:08:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34706
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbYDXBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:08:51 -0400
Date: Wed, 23 Apr 2008 18:08:49 -0700 (PDT)
Message-Id: <20080423.180849.240014014.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3iqy8f57m.fsf@maximus.localdomain>
References: <m34p9smrmp.fsf@maximus.localdomain>
	<20080423.154953.161012169.davem@davemloft.net>
	<m3iqy8f57m.fsf@maximus.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 02:48:29 +0200

> David Miller <davem@davemloft.net> writes:
> 
> > No, it was added as an optimization since the private
> > area was allocated together with the struct netdev, and
> > thus at a constant offset computable a compile time.
> 
> That's essentially what I meant. And it has changed, call it whatever
> you wish.

The core kernel code sets dev->priv to the alloc_netdev() allocated
memory region.

It doesn't do that just for fun.

Any code which overrides that setting is asking for trouble.
What if the code kernel code that set it, needed to use it
during device release for some reason?
