Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYBGTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYBGTwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYBGTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:52:33 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:56601 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYBGTwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:52:32 -0500
Date: Thu, 7 Feb 2008 20:51:36 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Farbod Nejati <farbodn@g2microsystems.com>
Cc: Philip Ryan <Philip.Ryan@g2microsystems.com>, linux-kernel@vger.kernel.org,
       "Chad O'Neill" <chad@g2microsystems.com>,
       Tom McDermott <tom.mcdermott@g2microsystems.com>
Subject: Re: SDIO driver not receiving responses
Message-ID: <20080207205136.1a38f4fe@poseidon.drzeus.cx>
In-Reply-To: <47A16C47.5090703@g2microsystems.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<47A16C47.5090703@g2microsystems.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't hijack threads, it completely messes up everyone's mail box and makes your mail very difficult to find.

On Thu, 31 Jan 2008 17:35:51 +1100
Farbod Nejati <farbodn@g2microsystems.com> wrote:

> The mmc_send_io_op_cond() function call in core.c::mmc_rescan() is 
> returning with a -110 (a timeout error). I traced this deeper and 
> noticed that CMD5 is being sent out via sdhci.c::sdhci_send_command() (I 
> verified this using a logic analyser, the host *is* transmitting a CMD5 
> [IO_SEND_OP_COND] packet in the correct format). However, when the 
> client responds with the IO_SEND_OP_COND Response R4 (SD mode), it does 
> not seem to be received by the host. Again, I verified using the logic 
> analyser that the response is as would be expected. An IRQ *is* 
> triggered, however it is 0x00018000 (SDHCI_INT_TIMEOUT|SDHCI_INT_ERROR). 
> I'm not too familiar with Linux kernel programming but I suspect that 
> whatever is waiting for a valid response is giving up instead and 
> triggering the above-mentioned interrupt instead.

That would be the hardware. We don't do any software timeout handling.

Have you checked the time from command to reply with the logic analyser? The chip might simply be out of spec.

> 
> Why would the output of the above code differ from the one produced by 
> lspci -xxx. Could this have something to do with this issue???
> 

lspci shows you the PCI config space, not the device io space, which is what your code dumped. ;)

> 
> I'm fresh out of ideas on this one and would greatly appreciate some 
> hints or assistance. I'm happy to provide any further information if needed.
> 

I can only see one of two options here. Either there is some miscalculation of the timeout, or you have a hardware bug. And to determine that we need to check what is actually going over the wire. As you've checked the data contents, that isn't the problem. So the only remaining thing is checking the timing.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
