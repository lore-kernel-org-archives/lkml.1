Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZIQS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZIQS5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbZIQS5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:57:47 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42827 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbZIQS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:57:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: fixing "pci=use_crs"
Date: Thu, 17 Sep 2009 12:57:48 -0600
User-Agent: KMail/1.9.10
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909171016.50087.bjorn.helgaas@hp.com> <20090917094527.051ca4bc@jbarnes-g45>
In-Reply-To: <20090917094527.051ca4bc@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200909171257.48851.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009 10:45:27 am Jesse Barnes wrote:
> > The extra resources in the old dmesg could be from "pci=use_crs"
> > being the default, but if that were the case, they should be in
> > the PNP resource dump.  Did you update the BIOS between those
> > boots?
> 
> FWIW in the CRS problem thread there were other reports of large
> numbers of PNP resources causing problems.  One solution I considered
> before we ended up reverting the patch was to increase the number of
> bus resources we track.  Rather than a small array of resources per
> bus, we could have a linked list, which would allow us to track an
> arbitrary number.

I think that might be a good starting point anyway, since I'm not
aware of any spec that limits the number of apertures a host bridge
can have.

> We probably want to distinguish between what we read from the hw regs
> and what's reported in PNP though, so maybe a new list in addition to
> the existing resource set would be the way to go.  That would allow us
> to selectively ignore PNP resources on machines where they report bogus
> ranges (or selectively look at them, either way).

When we can read things from hardware registers, I think we have to
trust that more than anything from other sources.  But I'm not proposing
any particular solution yet; I just want to get a better understanding
of what we're seeing.

Bjorn
