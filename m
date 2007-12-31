Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbXLaTKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbXLaTKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXLaTKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:10:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53569 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbXLaTKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:10:38 -0500
Date: Mon, 31 Dec 2007 11:10:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>, florian@openwrt.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] gpio: fix x86 build problem: gpio_keys
Message-Id: <20071231111016.eaab0c70.randy.dunlap@oracle.com>
In-Reply-To: <200712311040.28190.david-b@pacbell.net>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<20071231101837.65640746.randy.dunlap@oracle.com>
	<200712311040.28190.david-b@pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007 10:40:27 -0800 David Brownell wrote:

> On Monday 31 December 2007, Randy Dunlap wrote:
> >   CC      drivers/input/keyboard/gpio_keys.o
> > In file included from /local/linsrc/linux-2.6.24-rc6-mm1/drivers/input/keyboard/gpio_keys.c:27:
> > include2/asm/gpio.h:4:18: error: gpio.h: No such file or directory
> 
> Find whatever broken patch selected (on x86_64)
> 
>    CONFIG_GENERIC_GPIO=y
> 
> without actually providing that support (by providing <asm/gpio.h> and
> an implementation backing it up).  That's the patch which broke those
> various GPIO-dependant drivers.

OK, thanks for the direction.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

X86_RDC321X is X86_32, so make it depend on X86_32 so that
X86_64 random configs don't try to build RDC and fail.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc6-mm1.orig/arch/x86/Kconfig
+++ linux-2.6.24-rc6-mm1/arch/x86/Kconfig
@@ -297,6 +297,7 @@ config X86_ES7000
 
 config X86_RDC321X
 	bool "RDC R-321x SoC"
+	depends on X86_32
 	select M486
 	select X86_REBOOTFIXUPS
 	select GENERIC_GPIO
