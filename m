Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZBCAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZBCAMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZBCAMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:12:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:40675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZBCAMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:12:08 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902022356.33094.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>
	 <200902022333.51017.rjw@sisk.pl>  <200902022356.33094.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 11:11:21 +1100
Message-Id: <1233619881.18767.131.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 23:56 +0100, Rafael J. Wysocki wrote:
> * The ACPI_MTX_INTERPRETER mutex needs to be acquired, but we know we won't
>   need that mutex with interrupts off, so presumably we can work around this.

Or just make the mutex code not care when in the late suspend/early
resume. I think that's the right approach and involves no change to ACPI
itself.

> * Memory allocations with GFP_KERNEL are made, which is even worse, because
>   we really shouldn't do that during suspend _at_ _all_, even during the regular
>   ->suspend() with interrupts on, because there's not guarantee that swap will
>   will be available at that time.  So, for the sake of correctness, we should
>   get rid of the GFP_KERNEL from the ACPI code paths executed during
>   suspend-resume anyway.

Well, as I said, this is a problem with more than just ACPI and again, I
don't think the fix is to be done in ACPI itself. The buddy and slab
should basically stick NOIO or ATOMIC to any allocation done after we
started suspending the system.

Cheers,
Ben.


