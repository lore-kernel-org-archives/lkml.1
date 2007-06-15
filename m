Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXFOUsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXFOUsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXFOUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:48:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37207 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbXFOUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:48:06 -0400
X-IronPort-AV: i="4.16,426,1175486400"; 
   d="scan'208"; a="42303834:sNHT28744954"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 16:50:53 -0400
User-Agent: KMail/1.9.5
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Howells" <dhowells@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>
References: <200706151355.57464.ak@suse.de> <20070615135420.7fe2e4c1@the-village.bc.nu> <200706151454.28854.ak@suse.de>
In-Reply-To: <200706151454.28854.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151650.53481.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Jun 2007 20:48:02.0790 (UTC) FILETIME=[7777B860:01C7AF8E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15 Jun 2007 08:54, Andi Kleen pondered:
> On Friday 15 June 2007 14:54:20 Alan Cox wrote:
> 
> > > > > The network code requires unaligned accesses to work anyways so if 
your
> > > > > architecture doesn't support them it is already remotely crashable.
> > > >
> > > > I thought we'd fixed all that.
> > > 
> > > Did you audit the complete network stack?
> > 
> > For the parts used by the processors in question yes 
> 
> That means? They're expected to run only a subset of the network stack?
> Is that expressed in Kconfig? Is it documented that the rest is dangerous?

For the architecture we use (Blackfin), it does not support unaligned 
accesses, and we purposely never put in the trap/fixup code - we trap, and 
printk("fix your source");

We have run into a few kernel issues (never networking) this way - but a fixup 
of the source is normally the best solution - since it doesn't impose a 
hidden performance issue by trapping everything all the time.

> > people have done 
> > that work so using the types without unaligned.
> 
> Very brave; we're talking about around half a million lines
> of non trivial source code here.

Is there something specific that you can think of that we should be testing?

We have done alot of testing, and people have shipped alot of systems 
connected to a varity of networks, and have run all kinds of protocols on 
them.

-Robin
