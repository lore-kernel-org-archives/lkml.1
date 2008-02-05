Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbYBEUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbYBEUvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbYBEUuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:50:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:54642 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759245AbYBEUut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:50:49 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com>
References: <20080204151222.GB25790@localhost.sw.ru>
	 <1202162073.7079.8.camel@pasglop> <20080205091758.GB26618@localhost.sw.ru>
	 <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 07:49:52 +1100
Message-Id: <1202244592.7079.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> so x86_64 will work well?
> 
> the problem is that BIOS does not assign one resource for you tg3. and
> kernel pcibios_assign_to_unassign (?) try
> to assign resource to your card.

But the kernel shouldn't try to assign a resource in the 64 bits space
to a card behind a bridge... at least not a non-prefetchable resource
since those can't be forwarded (P2P bridges only define a 32 bits window
for non-prefetchable resources).

So it does look to me like the kernel may be doing something wrong. I
haven't had a chance to look at the logs in details yet (just woke up).

> revert the patch happen to work, you only have 2g less RAM (?), so
> 0x8000000 still can be used.
> 
> sometime you could get hang if your MB have two HT chains. ...because
> BIOS already allocate two io range for the two chain.
> and kernel may assign resource from the range1 belong to HT1 to device
> under HT0.
> solution: need pci root bios to provide _CRS to replace...
> and i have one patch but it only take care of 64 bit kernel for this case.
> 
> 
> easy solution for you: try to get one updated BIOS.


