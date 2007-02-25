Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXBYNQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXBYNQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 08:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXBYNQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 08:16:38 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:4249 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964959AbXBYNQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 08:16:37 -0500
Date: Sun, 25 Feb 2007 14:15:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2
Message-Id: <20070225141530.ba99c357.khali@linux-fr.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, all,

I appear to need the following fix to be able to build 2.6.20-mm2 on
x86_64. Without the fix, my build attempt dies on:

In file included from drivers/pci/quirks.c:532:
include/asm/io_apic.h:61: error: "MAX_IO_APICS" undeclared here (not in a function)

Not sure how nobody else was bitten by this one yet... i386 seems to
need the same so I've fixed it as well.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 include/asm-i386/io_apic.h   |    1 +
 include/asm-x86_64/io_apic.h |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.20.orig/include/asm-i386/io_apic.h	2007-02-25 13:01:40.000000000 +0100
+++ linux-2.6.20/include/asm-i386/io_apic.h	2007-02-25 14:01:33.000000000 +0100
@@ -3,6 +3,7 @@
 
 #include <asm/types.h>
 #include <asm/mpspec.h>
+#include <asm/apicdef.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.
--- linux-2.6.20.orig/include/asm-x86_64/io_apic.h	2007-02-25 13:01:43.000000000 +0100
+++ linux-2.6.20/include/asm-x86_64/io_apic.h	2007-02-25 13:54:31.000000000 +0100
@@ -3,6 +3,7 @@
 
 #include <asm/types.h>
 #include <asm/mpspec.h>
+#include <asm/apicdef.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.

-- 
Jean Delvare
