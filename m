Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXJGVvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXJGVvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbXJGVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:50:57 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43978
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752217AbXJGVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:50:56 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Date: Sun, 7 Oct 2007 16:50:49 -0500
User-Agent: KMail/1.9.6
Cc: "Miguel Ojeda" <maxextreme@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
References: <1191528247.13580.11.camel@grianne> <200710051126.50816.rob@landley.net> <19f34abd0710052310r2043f69ew70fe8b5f9ef0493c@mail.gmail.com>
In-Reply-To: <19f34abd0710052310r2043f69ew70fe8b5f9ef0493c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710071650.50627.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2007 1:10:26 am Vegard Nossum wrote:
> On 10/5/07, Rob Landley <rob@landley.net> wrote:
> > The original idea (selectively compile out printk() instances based on
> > log level to conserve space) is explicitly not addressed by this patch,
> > and in fact this patch might actually make it harder to implement (by
> > complicating the code).
>
> This is wrong. The patch provides log-level-based filtering at compile
> time, effectively making the kernel smaller.

I made it about halfway through the patch and the only compile time filtering 
I found was:

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -62,7 +62,10 @@
 #define MdpMinorShift 6
 
 #define DEBUG 0
-#define dprintk(x...) ((void)(DEBUG && printk(x)))
+#define dprintk(x...)          \
+       if(DEBUG) {             \
+                printk(x);     \
+       }

If you say it does, I'll take your word for it, but there's so much churn in 
there I didn't find it before my interest ran out...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
