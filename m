Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYGWRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYGWRKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYGWRKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:10:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45139 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbYGWRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:10:35 -0400
Subject: Re: acpi based pci gap calculation  - v3
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Len <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
In-Reply-To: <200807230958.32898.jbarnes@virtuousgeek.org>
References: <1216148382.6135.21.camel@alok-dev1>
	 <200807221450.52114.jbarnes@virtuousgeek.org>
	 <1216767168.5693.31.camel@alok-dev1>
	 <200807230958.32898.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 23 Jul 2008 10:10:34 -0700
Message-Id: <1216833034.6354.12.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Wed, 2008-07-23 at 09:58 -0700, Jesse Barnes wrote:
> On Tuesday, July 22, 2008 3:52 pm Alok Kataria wrote:
> > So the gap that we had calculated first i.e. from e820_setup_gap did
> > contain a collision i.e. though a resource was reserved from
> > [0xf0000000 - 0xf7ffffff] our gap calculation doesn't take that into
> > account.  My patch fixes this issue.
> >
> > So, IMHO this is a BUG and should be fixed. Please let me know your
> > views.
> 
> Yes, there's a conflict there, but on many machines it's probably a harmless
> one.  My main concerns are these:
>   1) it changes long standing behavior and doesn't fix any real reported bugs
>      I'm aware of (feel free to point me at some)

The problem that I see is with Memory Hotadd, though my BIOS exports the
correct SRAT table and tells the OS that some regions are hot pluggable,
PCI gap calculation ignores that info and assigns some "option ROMS" in
hot pluggable memory region. 

Because of this when i try to hot add memory, the OS sees a resource
allocation conflict and bails out. Which shouldn't have happened,
right ?

>   2) it looks like it will dramatically reduce the available PCI resource
>      space on at least some platforms, and that space is already scarce in our
>      current scheme

IMO, these gaps are used only for the option ROMS or hot pluggable
devices which in itself are rare. So its not like we are reducing the
whole available PCI resource space, but only the space that is needed by
these optional ROMS.
And i think its inevitable if we have to remove these conflicts with any
other subsystem. 
> 
> So basically, I'm just feeling very conservative about any changes to resource
> allocation, that's all.
> 
> If this change were coupled with one that allowed us to exploit more available
> address space for PCI resources I'd feel much more comfortable about it,
> which is why I'm so interested in TJ's work (/me goes off to read his wiki
> now).

/me to having a look.

Thanks,
Alok
> 
> Thanks,
> Jesse

