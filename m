Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZA2Smi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZA2Smi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZA2Sm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:42:26 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3473 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZA2SmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:42:25 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Thu, 29 Jan 2009 10:42:15 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Parag Warudkar" <parag.lkml@gmail.com>
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
Message-ID: <20090129184215.GA13459@xw6200.broadcom.net>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop>
 <alpine.LFD.2.00.0901281636270.3123@localhost.localdomain>
 <alpine.DEB.2.00.0901282049040.5026@parag-desktop>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0901282049040.5026@parag-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 659F27033FC43260671-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 05:49:18PM -0800, Parag Warudkar wrote:
> 
> 
> On Wed, 28 Jan 2009, Linus Torvalds wrote:
>  
> > For example, if we get the "dev->current_state" cache wrong, then we may 
> > not actually end up changing it when we should, because we think we 
> > already match the target state. I don't _think_ that is it, but that's the 
> > kind of thing that could happen.
> > 
> > Can you do a
> > 
> > 	lspci -vvxxx -s [tg3-device]
> > 
> > before-and-after suspend? Is there some state that looks like it got 
> > corrupted?
> 
> Sure, diff -u below. There are differences but not sure if they are 
> abnormal or expected.
> 
> Also, BTW, reverting the only tg3 specific commit - 
> commit 9e9fd12dc0679643c191fc9795a3021807e77de4
> Author: Matt Carlson <mcarlson@broadcom.com>
> Date:   Mon Jan 19 16:57:45 2009 -0800
> 
>     tg3: Fix firmware loading
> 
> did not help.
> 
> parag@parag-desktop:~$ diff -u lspci-pre-suspend lspci-post-suspend
> --- lspci-pre-suspend   2009-01-28 20:35:37.070584068 -0500
> +++ lspci-post-suspend  2009-01-28 20:36:56.922471408 -0500
> @@ -12,7 +12,7 @@
>         Capabilities: [50] Vital Product Data <?>
>         Capabilities: [58] Vendor Specific Information <?>
>         Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/0 Enable+
> -               Address: 00000000fee0f00c  Data: 41c9
> +               Address: 00000000fee0f00c  Data: 41d1
>         Capabilities: [d0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
> <4us, L1 unlimited
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> @@ -36,15 +36,15 @@
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 07 13
>  30: 00 00 04 20 48 00 00 00 00 00 00 00 03 01 00 00
>  40: 00 00 00 00 00 00 00 00 01 50 03 c0 08 20 00 64
> -50: 03 58 fc 00 00 00 00 78 09 e8 78 00 7d c9 08 78
> -60: 00 00 00 00 00 00 00 00 98 02 02 a0 00 00 18 76
> -70: f2 10 00 00 c0 00 00 00 2c 00 00 00 00 00 00 00
> -80: 3c 10 07 13 00 00 00 00 34 00 13 04 82 70 08 fc
> -90: 19 be 00 01 00 00 00 b7 00 00 00 00 14 00 00 00
> -a0: 00 00 00 00 4c 01 00 00 00 00 00 00 3e 01 00 00
> -b0: 00 00 00 00 00 00 00 36 00 00 00 00 00 00 00 00
> +50: 03 58 fc 00 00 00 00 78 09 e8 78 00 7e cb 08 a8
> +60: 00 00 00 00 00 00 00 00 9a 02 02 a0 00 00 00 10
> +70: 72 10 00 00 c0 00 00 00 2c 00 00 00 00 00 00 00
> +80: 3c 10 07 13 00 00 00 00 00 00 00 00 fe 70 08 fc
> +90: 11 be 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  c0: 00 00 00 00 00 80 00 00 0e 00 00 00 00 00 00 00
>  d0: 10 00 01 00 a0 8f 00 00 00 50 10 00 11 64 03 00
>  e0: 40 00 11 10 00 00 00 00 05 d0 81 00 0c f0 e0 fe
> -f0: 00 00 00 00 c9 41 00 00 00 00 00 00 00 00 00 00
> +f0: 00 00 00 00 d1 41 00 00 00 00 00 00 00 00 00 00

O.K.  These differences can probably be attributed to the driver's chip
reset failure.  For some reason, the driver has lost communication with
the firmware through the device's shared memory.  A cascading series of
errors will probably be the consequence.

Can you apply the following test patch and see if it helps?  The patch
does two things.  First, it enables a bit which should restore firmware
communication.  If that fixes the problem, then let me know and I'll
spin a proper patch.

In the event that it doesn't work, the patch goes on to test the memory
mapping by simply printing the register value at offset 0x0.  The value
should be the device's vendor ID and device ID.  Please post the
results so that I can verify it.


diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 8b3f846..39fce42 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -7227,6 +7227,11 @@ static int tg3_init_hw(struct tg3 *tp, int reset_phy)
 {
 	tg3_switch_clocks(tp);
 
+	printk( KERN_NOTICE "%s: Reg value at offset 0x0 is 0x%x\n",
+		tp->dev->name, tr32(0x0) );
+
+	tw32(MEMARB_MODE, tr32(MEMARB_MODE) | MEMARB_MODE_ENABLE);
+
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
 	return tg3_reset_hw(tp, reset_phy);

