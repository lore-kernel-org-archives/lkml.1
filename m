Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZFBPaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZFBPaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZFBPaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:30:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49741 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZFBPaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:30:02 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Date: Tue, 2 Jun 2009 17:29:58 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090602130649.GA14794@rhlx01.hs-esslingen.de>
In-Reply-To: <20090602130649.GA14794@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021729.58677.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX18c1yDBtGECOHoV19Dp2Hz5V/bUJM1EFbPxJIR
 XoT0wKntOs7uZxIlrVL3fRirsRzEFTHtQRtxpUNMLWGVq+qpEb
 3zdx54nEuF8E3G1X1J4AWkEb/MmoXvc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Dienstag, 2. Juni 2009 15:06:49 Andreas Mohr wrote:

Thanks for discovering this issue.

...
> ChangeLog:
> Make sure to properly bail out (call free_irq())
> after hfcpci interrupt detection failure.
> Improve comment.
>
> Signed-off-by: Andreas Mohr <andi@lisas.de>
>
> --- ./drivers/isdn/hardware/mISDN/hfcpci.c.orig	2009-06-02
> 13:54:10.000000000 +0200 +++
> ./drivers/isdn/hardware/mISDN/hfcpci.c	2009-06-02 14:29:20.000000000 +0200
> @@ -1172,7 +1172,7 @@ hfcpci_int(int intno, void *dev_id)
>  			printk(KERN_DEBUG
>  			    "HFC-PCI: stat(%02x) s1(%02x)\n", stat, val);
>  	} else {
> -		/* shared */
> +		/* (shared) IRQ triggered by other device */
>  		spin_unlock(&hc->lock);
>  		return IRQ_NONE;
>  	}

Hmm, I think shared as comment in the IRQ function should be
enough -  but  I do not complain to a longer comment.

> @@ -1807,8 +1807,7 @@ init_card(struct hfc_pci *hc)
>  			    "HFC PCI: IRQ(%d) getting no interrupts "
>  			    "during init %d\n", hc->irq, 4 - cnt);
>  			if (cnt == 1) {
> -				spin_unlock_irqrestore(&hc->lock, flags);
> -				return -EIO;
> +				goto fail;
>  			} else {
>  				reset_hfcpci(hc);
>  				cnt--;

easier:
			if (cnt == 1)
				break;
			else {


I will send this patch together with some other ISDN fixes again soon.

Karsten



