Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZBCEEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZBCEEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZBCEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:04:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:39637 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZBCEEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:04:46 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021941120.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902030045.19416.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
	 <200902030115.32659.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
	 <1233623525.18767.151.camel@pasglop>
	 <alpine.LFD.2.00.0902021729510.3247@localhost.localdomain>
	 <1233625606.18767.157.camel@pasglop> <1233631820.16867.27.camel@pasglop>
	 <alpine.LFD.2.00.0902021941120.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 15:03:50 +1100
Message-Id: <1233633830.16867.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 19:47 -0800, Linus Torvalds wrote:
> 
> On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> > On Tue, 2009-02-03 at 12:46 +1100, Benjamin Herrenschmidt wrote:
> > >
> > > Radeons don't do much with config space... the worst we may miss I
> > > suppose is subsystem vendor/device... Maybe I'll add something to
> > > explicitely save and restore it or X might get upset. I'll have a look.
> > 
> > Actually, subsystem stuff is below 0x40 so it should be fine too.
> 
> The things above 0x40 tend to be:
> 
>  - capabilities (values and next-pointers)
> 
>    The PCI layer will save a random couple of these (read: the ones it 
>    cares about)
> 
>  - random non-architected values specific to that chip. And sometimes 
>    these are important. Like ISA interrupt routing information for cardbus 
>    controllers. Or timing values set up by the BIOS.

Right, I've seen such things, but in our case, all the radeons I support
in there should be ok with just 64 bytes.

Cheers,
Ben.

