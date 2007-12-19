Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXLSNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXLSNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXLSNZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:25:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63024 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752442AbXLSNZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:25:17 -0500
Date: Wed, 19 Dec 2007 14:24:51 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Message-ID: <20071219142451.1e72f68c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712190518x384f06e7q39f8fd2a53e50d60@mail.gmail.com>
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
	<20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
	<3efb10970712190450p64d4e7a2k7b80d47349be9570@mail.gmail.com>
	<20071219141100.7384aff9@dhcp-252-066.norway.atmel.com>
	<3efb10970712190518x384f06e7q39f8fd2a53e50d60@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 14:18:18 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Haavard,
> 
> > Hrm. We probably need to lock while updating icount. That's a problem
> > since we do that from the tx interrupt handler...and I don't suppose we
> > want to move most of the atmel_tx_chars() code into the tasklet too...?
> 
> I do not see a reason why not moving transmit to a tasklet. It is only
> time critical to read in time. If the transmit is postponed for a
> while, it will only slow down transmission, while not reading in time
> results in lost data.

Ok, let's try that. But I'm afraid this means that we can't move the
sysrq processing back into hardirq context since if we're going to do
break handling, we need to update icount.brk as well.

Haavard
