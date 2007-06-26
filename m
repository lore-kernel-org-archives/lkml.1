Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXFZENQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXFZENQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXFZEND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:13:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXFZENB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:13:01 -0400
Date: Mon, 25 Jun 2007 21:12:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bob Picco" <bob.picco@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
Message-Id: <20070625211243.84a53d27.akpm@linux-foundation.org>
In-Reply-To: <20070621011422.GF10927@localhost>
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
	<20070621005122.GD10927@localhost>
	<20070620180711.1d4d6b6e.randy.dunlap@oracle.com>
	<20070621011422.GF10927@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 21:14:22 -0400 "Bob Picco" <bob.picco@hp.com> wrote:

> Randy Dunlap wrote:	[Wed Jun 20 2007, 09:07:11PM EDT]
> > On Wed, 20 Jun 2007 20:51:22 -0400 Bob Picco wrote:
> > 
> > > akpm@linux-foundation.org wrote:	[Wed Jun 20 2007, 01:14:34PM EDT]
> > > [snip]
> > > 
> > > Build breakage. pci_mmcfg_late_init is for i386.
> > 
> > then you want CONFIG_X86_32 instead of CONFIG_X86.
> > CONFIG_X86 is set/true for both X86_32 and X86_64.
> Then what I stated within the patch description is incorrect. pci.h which is the
> required include for the declaration is conditionally for CONFIG_X86. So it is
> both I guess?

(reads code and config files, works out that the breakage must have been ia64)

Really the header file should take care of this, and conditional inclusion
is evil.

So let's give this a whizz?


From: Andrew Morton <akpm@linux-foundation.org>

drivers/acpi/bus.c: In function `acpi_init':
drivers/acpi/bus.c:760: warning: implicit declaration of function `pci_mmcfg_late_init'

Fix this by always including pci.h in drivers/acpi/bus.c.

Also remove unneeded inclusion of asm/pci.h (linux/pci.h did that)

Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rajesh Shah <rajesh.shah@intel.com>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c |    3 +--
 linux/pci.h        |    0 
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/acpi/bus.c~mmconfig-validate-against-acpi-motherboard-resources-fix-2-3 drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~mmconfig-validate-against-acpi-motherboard-resources-fix-2-3
+++ a/drivers/acpi/bus.c
@@ -34,9 +34,8 @@
 #include <linux/proc_fs.h>
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
-#include <linux/pci.h>
-#include <asm/pci.h>
 #endif
+#include <linux/pci.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
_

