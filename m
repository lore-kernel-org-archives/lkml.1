Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZFHKrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZFHKrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZFHKro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:47:44 -0400
Received: from relay.atmel.no ([80.232.32.139]:51490 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbZFHKrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:47:43 -0400
Date: Mon, 8 Jun 2009 12:47:19 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Rob Emanuele <poorarm@shoreis.com>
Cc: Joey Oravec <joravec@drewtech.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH][Updated] New AT91 MCI Driver that supports both MCI
 slots used at the same time
Message-ID: <20090608124719.7c36840b@hskinnemoen-d830>
In-Reply-To: <c8284b5b0906031202u18433b52s1a0718ef627fddf0@mail.gmail.com>
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
	<4A1FFEFB.6050104@drewtech.com>
	<c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
	<4A269251.8090706@atmel.com>
	<4A269A83.3020008@drewtech.com>
	<c8284b5b0906031202u18433b52s1a0718ef627fddf0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele wrote:
> This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.

While I do understand the motivation for this patch, I was kind of
hoping we could reduce the number of drivers for the Atmel MCI
hardware, not increase it...

So I think it would be much better if your changes were integrated into
one of the existing drivers.

> Joey Oravec has mentioned that he has had better reliability with the chip
> he is using (AT91SAM9261) if the MMC controller is reset before each
> command.  There is a compile time option to do just that.

This could be a useful option for atmel-mci too.

> Joey Oravec has stated that the Read and Write Proof functionality that
> prevents buffer overflows is not available on the AT91SAM9261.  This was
> confirmed by Nicolas Ferre and also affects the AT91RM9200.  This new
> patch excludes those register config bits.

Preferably use the cpu_is_xxx() functions to achieve that. Perhaps even
wrap those tests inside a mci_has_xxproof() function to make it
clearer what you're testing for, and easier to change if we decide to
do the test based on version registers, etc. later.

Haavard
