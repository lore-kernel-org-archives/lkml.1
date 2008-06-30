Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYF3AeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYF3AeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYF3AeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:34:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYF3AeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:34:00 -0400
Date: Mon, 30 Jun 2008 02:45:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080630004544.GB19093@one.firstfloor.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu> <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl> <200806300106.38414.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806300106.38414.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Otherwise you throw this burden onto users who
> (1) don't expect things to stop working,
> (2) may not be able to figure out themselves what the right workaround is,
> (3) may not be able to make hardware manufacturers do anything.

Right thing would be to revert the guilty patches until these
problems are resolved.

> 
> If there's a configuration that worked before your patch and doesn't work
> after it, you're hurting the users of that configuration.

... also past experience is that DMI tables don't work well for this.
We tried that early when ACPI was still very problematic and it turned
out to be a flawed non-scalable strategy,

Typically the configurations causing problems are in multiple motherboards
with different DMI strings and it's very difficult to catch them all.

Also sometimes BIOS behaviour changes over versions and that's tricky to catch
with the standard DMI matches.

One way that would half way scale is to check for specific configurations
based on PCI-IDs and knowledge of the config space of these chipset, 
although it's also not ideal because often multiple chipset generations
with different PCI-IDs have similar issues.

-Andi

