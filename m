Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYBFKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYBFKk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYBFKks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:40:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:53617 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYBFKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tnk1r81x00XUt4RWcvtvDeNQoZJv/iAOFMEp9j51B5mzrhlQJvOQPzMN5uhOejUQggYVUBgO7AFURnW3sjlVF2C2ZSnqkvdCCBu8r2r2w2hS0TTjXaR+cimnw1Cvs68usqUaNuJ3ZsLK35OHZgnQQNglNm/nMxTYilK1bkbIauA=
Message-ID: <86802c440802060240n4b2ad0c9l1eb9ee049de13b5c@mail.gmail.com>
Date: Wed, 6 Feb 2008 02:40:46 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080206100510.GA29127@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204151222.GB25790@localhost.sw.ru>
	 <1202162073.7079.8.camel@pasglop>
	 <20080205091758.GB26618@localhost.sw.ru>
	 <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com>
	 <1202244592.7079.68.camel@pasglop>
	 <20080206100510.GA29127@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 2:05 AM, Alexey Dobriyan <adobriyan@sw.ru> wrote:
>
> On Wed, Feb 06, 2008 at 07:49:52AM +1100, Benjamin Herrenschmidt wrote:
> >
> > > so x86_64 will work well?
> > >
> > > the problem is that BIOS does not assign one resource for you tg3. and
> > > kernel pcibios_assign_to_unassign (?) try
> > > to assign resource to your card.
> >
> > But the kernel shouldn't try to assign a resource in the 64 bits space
> > to a card behind a bridge... at least not a non-prefetchable resource
> > since those can't be forwarded (P2P bridges only define a 32 bits window
> > for non-prefetchable resources).
> >
> > So it does look to me like the kernel may be doing something wrong. I
> > haven't had a chance to look at the logs in details yet (just woke up).
> >
> > > revert the patch happen to work, you only have 2g less RAM (?), so
> > > 0x8000000 still can be used.
> > >
> > > sometime you could get hang if your MB have two HT chains. ...because
> > > BIOS already allocate two io range for the two chain.
> > > and kernel may assign resource from the range1 belong to HT1 to device
> > > under HT0.
> > > solution: need pci root bios to provide _CRS to replace...
> > > and i have one patch but it only take care of 64 bit kernel for this case.
> > >
> > >
> > > easy solution for you: try to get one updated BIOS.
>
> BTW, "[PATCH] x86_32: fix regression caused by trim ram according to mtrr on system with 4G more RAM"
> http://marc.info/?l=linux-kernel&m=120229095121673&w=2
> fixes this box too and I have back all 4G of RAM as a bonus. :-)

so you have 4g ram, and with hw memhole enabled? BIOS should have Tom2
set, and WB set ..

you must have rev C or Rev E instead of rev F?

can you post the /proc/mtrrs and boot message?

YH
