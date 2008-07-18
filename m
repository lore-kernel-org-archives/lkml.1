Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYGRHk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYGRHk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYGRHkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:40:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYGRHkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=b9y6gpJ4jApu9dWUq+6z2poIw1FivMi6BNGTG3yf2riRdHssgOj87MT2zOjBD+w+ku
         C9OR8ffxqUsQa8wr8C7d3x/ONP+khZygbYMGC2PlU56cnpIyYn6+BNkIReH6yMkBNNCh
         6DHV/7t/4sR1LP5K96yg8eSnAizXa2ceQdIF0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:27 +0900
Message-Id: <20080718074027.32713.15674.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/05] resource: add new IORESOURCE_CLK type V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

So far struct resource has been used with the types IORESOURCE_MEM,
IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and interrupt parameters
to platform drivers. This patch extends this with IORESOURCE_CLK which
should be used to pass a clock string to the platform driver. This
string points out which specific clock that should be used with clk_get()
for a certain driver instance.

Using a hard coded strings in the device driver won't do since we may
have multiple instances of drivers that need to use different clocks.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
 - Use a new bit for IORESOURCE_CLK instead of switching to a counter

 include/linux/ioport.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- 0003/include/linux/ioport.h
+++ work/include/linux/ioport.h	2008-07-18 14:29:48.000000000 +0900
@@ -34,20 +34,21 @@ struct resource_list {
  */
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
-#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
+#define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
+#define IORESOURCE_CLK		0x00001000
 
-#define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
-#define IORESOURCE_READONLY	0x00002000
-#define IORESOURCE_CACHEABLE	0x00004000
-#define IORESOURCE_RANGELENGTH	0x00008000
-#define IORESOURCE_SHADOWABLE	0x00010000
+#define IORESOURCE_PREFETCH	0x00002000	/* No side effects */
+#define IORESOURCE_READONLY	0x00004000
+#define IORESOURCE_CACHEABLE	0x00008000
+#define IORESOURCE_RANGELENGTH	0x00010000
+#define IORESOURCE_SHADOWABLE	0x00020000
 
-#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
-#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
+#define IORESOURCE_SIZEALIGN	0x00040000	/* size indicates alignment */
+#define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
 
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
