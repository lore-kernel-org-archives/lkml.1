Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXHWFfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXHWFfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXHWFfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:35:38 -0400
Received: from ozlabs.org ([203.10.76.45]:40024 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbXHWFfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:35:37 -0400
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20070822222528.7c58f1e9@the-village.bc.nu>
References: <46CBC842.4070100@vmware.com>
	 <20070822102217.GE2642@bingen.suse.de> <46CC68D9.5060200@vmware.com>
	 <20070822175918.GB8058@bingen.suse.de> <46CC6D63.2010204@vmware.com>
	 <20070822194632.GD8058@bingen.suse.de> <46CC9FF2.3040406@vmware.com>
	 <20070822220451.GJ8058@bingen.suse.de>
	 <20070822222528.7c58f1e9@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 15:34:56 +1000
Message-Id: <1187847296.16369.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 22:25 +0100, Alan Cox wrote:
> > I still think it's preferable to change some drivers than everybody.
> > 
> > AFAIK BusLogic as real hardware is pretty much dead anyways,
> > so you're probably the only primary user of it anyways.
> > Go wild on it!
> 
> I don't believe anyone is materially maintaining the buslogic driver and
> in time its going to break completely.
> 
> > Well that might be. I just think it would be a mistake
> > to design paravirt_ops based on someone's short term release engineering
> > considerations.
> 
> Agreed, especially as an interface where each in or out traps into the
> hypervisor is broken even for the model of virtualising hardware. 

I'd really like lguest guests not to do ins and outs, but that's likely
to be more invasive a change than this.  We do it to find the PCI bus
IIRC, and a couple of other early probe bits.

It's just unfortunate that it's the one place lguest has to emulate
because of lack of paravirt_ops coverage.

Rusty.

