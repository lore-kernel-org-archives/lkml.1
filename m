Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbXFELYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbXFELYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762970AbXFELYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:24:10 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:60353 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758205AbXFELYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:24:09 -0400
Date: Tue, 5 Jun 2007 13:23:36 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ivan Kuten <ivan.kuten@promwad.com>
Cc: Andrew Victor <andrew@sanpeople.com>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Fix break handling
Message-ID: <20070605132336.3b8a9a4e@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070605140720.4bdf887a@newbox>
References: <11806398911702-git-send-email-hskinnemoen@atmel.com>
	<20070605140720.4bdf887a@newbox>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 14:07:20 +0300
Ivan Kuten <ivan.kuten@promwad.com> wrote:

> I tried to test your patch on AT91RM9200 with Magic SysRq sequence, unfortunately without 
> success - SysRq still does not work. You mention "break count increments" where do you check it ? I have 
> cat /proc/tty/driver/atmel_serial 
> serinfo:1.0 driver revision:
> 0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:8554 rx:623 fe:25 RTS|CTS|DTR|DSR|CD|RI
> 1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI
> 2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI
> 3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:0 rx:0 DSR|CD|RI
> 4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 CTS|DSR|CD|RI
> 
> no any break counter.

Andrew Victor pointed out that the RM9200 DBGU doesn't support break at
all, and the data sheet seems to agree. The break counter seems to show
up after the first break has been received and you're probably not
receiving any.

Is it possible for you to try a different USART as console?

Haavard
