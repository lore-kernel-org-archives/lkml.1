Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbXHGOKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbXHGOKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXHGOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:10:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbXHGOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:10:44 -0400
Date: Tue, 7 Aug 2007 16:10:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT support for i386 and x86_64
Message-ID: <20070807141042.GB952@one.firstfloor.org>
References: <6278d2220708070534t7096e579uef2ddbb2c997daa6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220708070534t7096e579uef2ddbb2c997daa6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What cases did you have in mind?

Mainly mapping memory which is rather tricky.

> From current Intel 64 and IA-32 Architectures Software Developer's Manual
> Volume 3A: System Programming Guide, section 10.5.2:

If you look at the detailed table it's not that simple.

> > Then there are old CPU errata that need to be handled etc.
> 
> I don't see a problem with having CONFIG_PAT depend on P4/Athlon or
> newer to avoid such workarounds for now. Better to have something
> there which works in (only) 80% of the cases, than nothing at all.

Agreed, but the patch doesn't do that.

> > You didn't solve all that at all. If it was as simple as your patch
> > we would have long done it already.
> 
> Perhaps this feature can be marked as WIP to allow this to move
> forward while corner-cases are worked out. Adding such a go/no-go

We're not going to have potentially cache corrupting features
as WIP. The last time one such bug took months to track down.

> barrier will hamper progress we do see, as it has done already for
> years.

Because it's not simple and nobody has done it properly yet.

> The PCI ordering config option years ago was a similar case, since
> various drivers didn't issue wmb()s until they were fixed up.

wmb alone is not enough for PCI ordering.

-Andi
