Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXKSATo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXKSATo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 19:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbXKSATg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 19:19:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42322 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbXKSATf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 19:19:35 -0500
Date: Sun, 18 Nov 2007 16:17:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 2.6.24-rc3 - 64-bit DMA fails for BCM94311MCG rev
 02
Message-ID: <20071118161727.106e7eea@laptopd505.fenrus.org>
In-Reply-To: <4740D323.3090107@lwfinger.net>
References: <4740D323.3090107@lwfinger.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 18:04:51 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I get a failure of 64-bit DMA on a BCM94311MCG rev 02 wireless
> interface running on x86_64 using an AMD Turion 64 X2 processor on an
> HP Pavilion dv2125nr laptop. The error code indicates that the
> interface is getting a descriptor read error, even though the
> descriptor ring and all the DMA buffers have been checked when
> allocated. This particular card version is newly supported; however,
> it was working correctly on 2.6.24-rc2.
> 


worth adding a pci_set_dma_mask(pdev, DMA_32BIT_MASK); in the driver,
just after pci_enable_device(); (also check if there's other
pci_set_dma_mask functions, to make sure it doesn't get set back to 64
bit)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
