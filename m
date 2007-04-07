Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXDGFMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXDGFMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXDGFMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:12:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:55976 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXDGFMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:12:44 -0400
Subject: Re: [PATCH] PPC4xx UART0 (8250) problem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mikhail Zolotaryov <lebon@faust.net.ua>
Cc: mporter@kernel.crashing.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46171C50.3020104@faust.net.ua>
References: <46171C50.3020104@faust.net.ua>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 15:12:36 +1000
Message-Id: <1175922756.7407.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 07:21 +0300, Mikhail Zolotaryov wrote:
> On PPC4xx embedded we often have UART0 on IRQ0 but 8250 UART driver
> uses IRQ0 as "no irq" hack. It's suggested that platforms with UART
> on IRQ0 will redefine is_real_interrupt(irq) macro but 8250 code
> anyway overrides that. As the result, serial line on UART0 works
> on polling-way and we have character loss on high baud rates.
> 
> In patch I added check if UART0 is on IRQ0, if so we define
> is_real_interrupt macro to be 1 (true). Also, check if
> is_real_interrupt macro is already defined added to 8250 UART
> driver.

This is an old problem. The proper fix is already implemented for
arch/powerpc and consist of having virtual irq numbers (which helps for
many other things anyway).

Support for 4xx platforms in arch/powerpc is starting to get in, pop on
linuxppc-dev@ozlabs.org where the patches are being posted and you are
welcome to give a hand porting more platforms over :-)

Ben.


