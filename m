Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbXG0BtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbXG0BtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXG0BtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:49:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbXG0Bs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:48:59 -0400
Date: Thu, 26 Jul 2007 18:48:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Curry <pacman@theworld.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Message-Id: <20070726184800.0bb3b9fb.akpm@linux-foundation.org>
In-Reply-To: <1185347565.5439.310.camel@localhost.localdomain>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
	<1185347565.5439.310.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 17:12:45 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2007-07-24 at 21:28 -0400, Alan Curry wrote:
> > As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse controller
> > on the PegasosPPC. This is because of a feature/bug in the OF device tree:
> > the "device_type" attribute is an empty string instead of "8042" as the
> > kernel expects. This patch (against 2.6.22.1) adds a secondary detection
> > which looks for a device whose *name* is "8042" if there is no device whose
> > *type* is "8042".
> > 
> > Signed-off-by: Alan Curry <pacman@world.std.com>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Note, if there's a volunteer, we could probably turn that code into a
> nice table lookup.

Did this get merged, or otherwise fixed?  Even though the code in there has
changed quite a bit, it looks to my untrained eye like the fix is still
applicable?


From: Alan Curry <pacman@TheWorld.com>

As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse
controller on the PegasosPPC.  This is because of a feature/bug in the OF
device tree: the "device_type" attribute is an empty string instead of
"8042" as the kernel expects.  This patch (against 2.6.22.1) adds a
secondary detection which looks for a device whose *name* is "8042" if
there is no device whose *type* is "8042".

Signed-off-by: Alan Curry <pacman@world.std.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null /dev/null
diff -puN arch/powerpc/kernel/setup-common.c~powerpc-pegasos-keyboard-detection arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~powerpc-pegasos-keyboard-detection
+++ a/arch/powerpc/kernel/setup-common.c
@@ -496,6 +496,12 @@ int check_legacy_ioport(unsigned long ba
 			break;
 		}
 		np = of_find_node_by_type(NULL, "8042");
+		/*
+		 * Pegasos has no device_type on its 8042 node, look for the
+		 * name instead
+		 */
+		if (!np)
+			np = of_find_node_by_name(NULL, "8042");
 		break;
 	case FDC_BASE: /* FDC1 */
 		np = of_find_node_by_type(NULL, "fdc");
_


And ALan says that 2.6.22 is bust, but this patch no won't apply there so
if we want to fix 2.6.22.x then Alan's original patch would be needed.

