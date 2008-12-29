Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYL2Q5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYL2Q5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYL2Q53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:57:29 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:44709 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYL2Q52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:57:28 -0500
Date: Mon, 29 Dec 2008 17:57:21 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] Remove obsolete CONFIG_RESOURCES_64BIT (was: Re: [PATCH
 3/3] redefine resource_size_t as phys_addr_t)
In-Reply-To: <48C8D776.1020204@goop.org>
Message-ID: <Pine.LNX.4.64.0812291753560.14380@anakin>
References: <48C8D776.1020204@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008, Jeremy Fitzhardinge wrote:
> There's no good reason why a resource_size_t shouldn't just be a
> physical address, so simply redefine it in terms of phys_addr_t.

And hence CONFIG_RESOURCES_64BIT became unused.

Subject: [PATCH/RFC] Remove obsolete CONFIG_RESOURCES_64BIT

commit 8308c54d7e312f7a03e2ce2057d0837e6fe3843f ("generic: redefine
resource_size_t as phys_addr_t") made CONFIG_RESOURCES_64BIT obsolete, but
didn't remove it. Remove it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Although sometimes I'm longing for the days I could hunt for "warning: cast
to pointer from integer of different size" when enabling it...

diff --git a/mm/Kconfig b/mm/Kconfig
index 5b5790f..a5b7781 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -181,12 +181,6 @@ config MIGRATION
 	  example on NUMA systems to put pages nearer to the processors accessing
 	  the page.
 
-config RESOURCES_64BIT
-	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT && EXPERIMENTAL)
-	default 64BIT
-	help
-	  This option allows memory and IO resources to be 64 bit.
-
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
