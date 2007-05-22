Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbXEVAcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbXEVAcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbXEVAcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:32:45 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:55875 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbXEVAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:32:44 -0400
Date: Tue, 22 May 2007 01:31:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <20070522003153.GA18162@srcf.ucam.org>
References: <200705171517.14087.lenb@kernel.org> <1179604609.16465.83.camel@sublime.suse.de> <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521224200.GF10714@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 12:42:00AM +0200, Pavel Machek wrote:
> On Mon 2007-05-21 14:45:53, Matthew Garrett wrote:
> > So don't do it badly. The advantage of doing so is that you can make it 
> > work properly, which you can't by putting it in the kernel.
> 
> You want stuff like critical shutdowns to work even if userspace is
> dead.

I don't think anyone suggested putting the critical shutdown control in 
userspace. The kernel already handles that fine.

> I do not think you can control passive cooling adequately from 
> userspace, and you can certainly not prevent kernel from slowing 
> machine down too soon.

Given the choice between something impossible and something difficult, 
I'm inclined towards picking the difficult one.

> Plus, this is actually nasty user-visible change, and a regression
> from 2.6.21. I am not sure why we are even debating this; user-kernel
> interface changed without warning. Patch should be simply reverted.

In http://lkml.org/lkml/2007/1/27/93 you were more than happy to break 
an interface even though it could be fixed in a (ugly) way that made it 
work again. Here, there's no way to fix this properly - the platform 
will quite happily do things based on what it believes the trip points 
should be, and one of those things may be to alter the trip points. 
Imagine the following situation:

1) Platform sets critical shutdown trip point to 85C
2) Userspace sets critical shutdown trip point to 95C
3) Temperature reaches 90C
4) Platform forces reevaluation of trip points
5) Entire invasion fleet is lost

How do you avoid that? Disable the ability for the platform to set trip 
points? You're breaking the spec and potentially causing hardware 
damage. If you have specific hardware that requires specific spec 
breakage, then a better approach would probably be to quirk the kernel 
to rectify it. On the other hand, if it works with the Other Leading OS, 
we ought to be able to just fix the problem properly.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
