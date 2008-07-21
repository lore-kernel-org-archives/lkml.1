Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYGUTk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYGUTk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYGUTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:40:17 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:8515 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYGUTkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:40:16 -0400
Date: Mon, 21 Jul 2008 21:40:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Russ Anderson <rja@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
Message-ID: <20080721194000.GE29543@basil.nowhere.org>
References: <20080718203514.GD29621@sgi.com> <87prpa88iw.fsf@basil.nowhere.org> <20080720173914.GA9409@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720173914.GA9409@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jul 2008 19:39:56.0533 (UTC) FILETIME=[8DEDE250:01C8EB69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 12:39:14PM -0500, Russ Anderson wrote:
> The patch has a module for IA64, based on experience on IA64 hardware.
> It is a first step, to get the basic functionality in the kernel.

The basic functionality doesn't seem flexible enough for me 
for useful policies.

> (~20,000 in one customer system).  So disabling the memory on a
> DIMM with a flaky connector is a small percentage of overall memory.
> On a large NUMA machine the flaky DIMM connector would only effect
> memory on one node.

You would still lose significant parts of that node, won't you?
Even on the large systems people might miss a node or two.

> A good enhancement would be to migrate all the data off a DRAM and/or
> DIMM when a threshold is exceeded.  That would take knowledge of the
> physical memory to memory map layout.  

Would be probably difficult to teach this the kernel in a nice generic
way. In particular interleaving is difficult.

> > If you really wanted to do this you probably should hook it up
> > to mcelog's (or the IA64 equivalent) DIMM database
> 
> Is there an IA64 equivalent?  I've looked at the x86_64 mcelog,
> but have not found a IA64 version.

There's a sal logger process in user space I believe, but I have never looked 
at it. It could do these things in theory.
Also in the IA64 case the firmware can actually tell the kernel
what to do because it gets involved here (and firmware often
has usable heuristics for this case) 

> > and DIMM specific knowledge. But it's unlikely it can be really
> > done nicely in a way that is isolated from very specific 
> > knowledge about the underlying memory configuration.
> 
> Agreed.  An interface to export the physical memory configuration
> (from ACPI tables?) would be useful.

On x86 there's currently only DMI/SMBIOS for this, but it has some issues.

-Andi

