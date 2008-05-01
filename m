Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYEAUE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYEAUE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYEAUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:04:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49789 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:04:46 -0400
Date: Thu, 1 May 2008 22:11:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why such a big difference in init-time PCI resource call-paths (x86 vs x86_64) ?
Message-ID: <20080501201111.GO20451@one.firstfloor.org>
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net> <200805011116.31782.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805011116.31782.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
> On Wednesday, April 30, 2008 9:07 am TJ wrote:
> > In preparation for writing a Windows-style PCI resource allocation
> > strategy
> >
> >  - use all e820 gaps for IOMEM resources; top-down allocation -
> >
> > and thus giving devices with large IOMEM requirements more chance of
> > allocation in the 32-bit address space below 4GB (see bugzilla #10461),

I tried that some time ago and it turned out that some systems have
mappings in holes and don't boot anymore when you fill the holes too much. 
But that was only considering e820. if you do this it might work if you 
do it really like windows and consider all resources, including ACPI.

> > So, why the big difference in implementations?
> > What are the implications of each?
> > Is one preferable to the other?

I don't remember why it is different. Probably wasn't intentional.
But in general x86-64 is less fragile than i386 here because it has the e820
allocator and can deal better with conflicts.

-Andi
