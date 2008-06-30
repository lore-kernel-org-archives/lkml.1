Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYF3Ara@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYF3Ara (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYF3ArU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:47:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47460 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYF3ArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:47:19 -0400
Date: Mon, 30 Jun 2008 01:47:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080630004711.GA14118@srcf.ucam.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu> <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl> <200806300106.38414.rjw@sisk.pl> <20080630004544.GB19093@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630004544.GB19093@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:45:44AM +0200, Andi Kleen wrote:

> ... also past experience is that DMI tables don't work well for this.
> We tried that early when ACPI was still very problematic and it turned
> out to be a flawed non-scalable strategy,
> 
> Typically the configurations causing problems are in multiple motherboards
> with different DMI strings and it's very difficult to catch them all.
> 
> Also sometimes BIOS behaviour changes over versions and that's tricky to catch
> with the standard DMI matches.

In this specific case, the problem is clearly due to nonsensical code in 
the DSDT that alters the thermal trip points based on ioapic 
configuration. It's only been observed on two almost identical models 
from one manufacturer, and doesn't occur on any other known machines 
with the same chipset. I think it's safe to special-case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
