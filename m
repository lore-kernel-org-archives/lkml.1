Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbXFELch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbXFELch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXFELc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:32:29 -0400
Received: from 42.242.232.72.static.reverse.layeredtech.com ([72.232.242.42]:49568
	"EHLO secure.poehali.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXFELc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:32:28 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 07:32:28 EDT
Date: Tue, 5 Jun 2007 14:07:20 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Fix break handling
Message-ID: <20070605140720.4bdf887a@newbox>
In-Reply-To: <11806398911702-git-send-email-hskinnemoen@atmel.com>
References: <11806398911702-git-send-email-hskinnemoen@atmel.com>
Organization: Promwad
X-Mailer: Sylpheed-Claws 1.9.100cvs93 (GTK+ 2.8.7; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Assp-Whitelisted: Yes
X-Assp-Envelope-From: ivan.kuten@promwad.com
X-Assp-Intended-For: hskinnemoen@atmel.com andrew@sanpeople.com
	rmk@arm.linux.org.uk nicolas.ferre@rfo.atmel.com patrice.vilchez@rfo.atmel.com
	linux-kernel@vger.kernel.org hskinnemoen@atmel.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - secure.poehali.org
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - promwad.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 21:31:31 +0200
Haavard Skinnemoen wrote:

> It's been almost a year since the last patch I sent attempting to fix
> this. Sorry for not following up any sooner.
> 
> Anyway, here's a new attempt. It should work even if we miss some
> interrupts, and it should not break break handling by ignoring the
> return value from uart_handle_break() as Russell pointed out.
> 
> There may be cases which aren't handled well: If you send two breaks
> with no characters in between and we miss an interrupt on the first
> one, the driver probably gets a bit confused. I don't see any way to
> fix this, but the driver should get un-confused upon reception of the
> next character.
> 
> I've tested this with Magic SysRq on ATSTK1000: It works with this
> patch but not without. Ivan Kuten reported in a different thread that
> SysRq didn't work on AT91RM9200 and I very much doubt it works on
> AT91SAM926x.
> 
> The break count in /proc/tty/driver/atmel_serial also makes more sense
> with this patch applied; without it, the break count increments by two
> every time I send a break.
> 
>  drivers/serial/atmel_serial.c |   32 ++++++++++++++++++++++++++++++--
>  1 files changed, 30 insertions(+), 2 deletions(-)
> 

Hi Haavard, 

I tried to test your patch on AT91RM9200 with Magic SysRq sequence, unfortunately without 
success - SysRq still does not work. You mention "break count increments" where do you check it ? I have 
cat /proc/tty/driver/atmel_serial 
serinfo:1.0 driver revision:
0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:8554 rx:623 fe:25 RTS|CTS|DTR|DSR|CD|RI
1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI
2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI
3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:0 rx:0 DSR|CD|RI
4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 CTS|DSR|CD|RI

no any break counter.

BR,
Ivan



