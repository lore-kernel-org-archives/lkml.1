Return-Path: <linux-kernel-owner+w=401wt.eu-S1763137AbXEWAJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763137AbXEWAJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXEWAIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:08:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41003 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbXEWAIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:08:35 -0400
Date: Mon, 21 May 2007 15:11:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linuxsh-dev@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2 prepatch breaks compile on Dreamcast
Message-ID: <20070521061137.GB14877@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linuxsh-dev@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1179576420.5998.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179576420.5998.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 01:07:00PM +0100, Adrian McMenamin wrote:
> The patch includes:
> 
> -#if OFFCHIP_NR_IRQS > 0
> -# define OFFCHIP_IRQ_BASE (ONCHIP_NR_IRQS + PINT_NR_IRQS)
> -#endif
> 
> 
> but the OFFCHIP_IRQ_BASE symbol is still referenced in the Dreamcast
> code, so a compile generates this:
> 
This will fix it, queued for -rc3:

diff --git a/include/asm-sh/dreamcast/sysasic.h b/include/asm-sh/dreamcast/sysasic.h
index 7874e3d..f334266 100644
--- a/include/asm-sh/dreamcast/sysasic.h
+++ b/include/asm-sh/dreamcast/sysasic.h
@@ -23,7 +23,7 @@
    takes.
 */
 
-#define HW_EVENT_IRQ_BASE  OFFCHIP_IRQ_BASE /* 48 */
+#define HW_EVENT_IRQ_BASE  48
 
 /* IRQ 13 */
 #define HW_EVENT_VSYNC     (HW_EVENT_IRQ_BASE +  5) /* VSync */
