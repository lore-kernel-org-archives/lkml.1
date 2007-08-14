Return-Path: <linux-kernel-owner+w=401wt.eu-S935578AbXHNWth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935578AbXHNWth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXHNWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:49:13 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56488 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXHNWtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:49:11 -0400
Date: Wed, 15 Aug 2007 00:46:29 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Karl Meyer <adhocrocker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Message-ID: <20070814224629.GB3495@electric-eye.fr.zoreil.com>
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com> <20070813165821.GA19356@electric-eye.fr.zoreil.com> <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com> <20070814070901.GA14693@electric-eye.fr.zoreil.com> <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Meyer <adhocrocker@gmail.com> :
> I did some additional testing, the results are:
> [0e4851502f846b13b29b7f88f1250c980d57e944] r8169: merge with version
> 8.001.00 of Realtek's r8168 driver
> does not work, I after some traffic the transmit timeout occurs.
> [6dccd16b7c2703e8bbf8bca62b5cf248332afbe2] r8169: merge with version
> 6.001.00 of Realtek's r8169 driver
> Seems to be the last version to work. I did some stress testing (much
> more than the level that was enough to make
> [0e4851502f846b13b29b7f88f1250c980d57e944]  break) and am currently
> using this version and no problems so far.

Thanks for the quick feedback.

Can you try the patch below on top of 2.6.23-rc3 ?

If it does not work I'll dissect 0e4851502f846b13b29b7f88f1250c980d57e944
tomorrow.

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b85ab4a..cdb8a08 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2749,6 +2749,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 		if (!(status & tp->intr_event))
 			break;
 
+#if 0
                 /* Work around for rx fifo overflow */
                 if (unlikely(status & RxFIFOOver) &&
 		    (tp->mac_version == RTL_GIGA_MAC_VER_11)) {
@@ -2756,6 +2757,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 			rtl8169_tx_timeout(dev);
 			break;
 		}
+#endif
 
 		if (unlikely(status & SYSErr)) {
 			rtl8169_pcierr_interrupt(dev);
-- 
Ueimor
