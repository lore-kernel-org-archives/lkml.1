Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbYBFKFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbYBFKFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760663AbYBFKFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:05:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22665 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760629AbYBFKFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:05:20 -0500
Date: Wed, 6 Feb 2008 13:05:10 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Message-ID: <20080206100510.GA29127@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru> <1202162073.7079.8.camel@pasglop> <20080205091758.GB26618@localhost.sw.ru> <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com> <1202244592.7079.68.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202244592.7079.68.camel@pasglop>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 07:49:52AM +1100, Benjamin Herrenschmidt wrote:
> 
> > so x86_64 will work well?
> > 
> > the problem is that BIOS does not assign one resource for you tg3. and
> > kernel pcibios_assign_to_unassign (?) try
> > to assign resource to your card.
> 
> But the kernel shouldn't try to assign a resource in the 64 bits space
> to a card behind a bridge... at least not a non-prefetchable resource
> since those can't be forwarded (P2P bridges only define a 32 bits window
> for non-prefetchable resources).
> 
> So it does look to me like the kernel may be doing something wrong. I
> haven't had a chance to look at the logs in details yet (just woke up).
> 
> > revert the patch happen to work, you only have 2g less RAM (?), so
> > 0x8000000 still can be used.
> > 
> > sometime you could get hang if your MB have two HT chains. ...because
> > BIOS already allocate two io range for the two chain.
> > and kernel may assign resource from the range1 belong to HT1 to device
> > under HT0.
> > solution: need pci root bios to provide _CRS to replace...
> > and i have one patch but it only take care of 64 bit kernel for this case.
> > 
> > 
> > easy solution for you: try to get one updated BIOS.

BTW, "[PATCH] x86_32: fix regression caused by trim ram according to mtrr on system with 4G more RAM"
http://marc.info/?l=linux-kernel&m=120229095121673&w=2
fixes this box too and I have back all 4G of RAM as a bonus. :-)

