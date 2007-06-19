Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXFSKd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXFSKd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXFSKdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:33:19 -0400
Received: from 42.242.232.72.static.reverse.layeredtech.com ([72.232.242.42]:56706
	"EHLO secure.poehali.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbXFSKdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:33:18 -0400
Date: Tue, 19 Jun 2007 13:36:05 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Fix break handling
Message-ID: <20070619133605.30e7655e@newbox>
In-Reply-To: <20070618103353.GB10387@flint.arm.linux.org.uk>
References: <11806398911702-git-send-email-hskinnemoen@atmel.com>
	<20070605140720.4bdf887a@newbox>
	<20070605132336.3b8a9a4e@dhcp-255-175.norway.atmel.com>
	<20070618132121.2d00a907@newbox>
	<20070618103353.GB10387@flint.arm.linux.org.uk>
Organization: Promwad
X-Mailer: Sylpheed-Claws 1.9.100cvs93 (GTK+ 2.8.7; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Assp-Whitelisted: Yes
X-Assp-Envelope-From: ivan.kuten@promwad.com
X-Assp-Intended-For: rmk+lkml@arm.linux.org.uk hskinnemoen@atmel.com
	andrew@sanpeople.com nicolas.ferre@rfo.atmel.com patrice.vilchez@rfo.atmel.com
	linux-kernel@vger.kernel.org
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

On Mon, 18 Jun 2007 11:33:54 +0100
Russell King wrote:

> On Mon, Jun 18, 2007 at 01:21:21PM +0300, Ivan Kuten wrote:
> > Hi Haavard,
> > 
> > I tried /dev/ttyAT3, break appeared but not the way I expected, after:
> > stty -F /dev/ttyAT3 brkint I get:
> > 
> > cat /proc/tty/driver/atmel_serial 
> > serinfo:1.0 driver revision:
> > 0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:0 rx:0 CTS|DSR|CD|RI
> > 1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI             
> > 2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI                        
> > 3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:1530 rx:115 brk:1 RTS|DTR|DSR|CD|RI
> > 4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 DSR|CD|RI  
> > 
> > brk is 1 not depending on how many breaks was sent. May be I missunderstood
> > "break" meaning?
> > I use from minicom: Main Functions : send break.........F . 
> 
> Note that if you want to use magic sysrq on ttyAT3, you need the kernel
> console on ttyAT3.  Since you successfully received one break event on
> ttyAT3, the next character should have caused a sysrq event.
> 

Yes, I added to kernel command line "console=ttyAT3,115200" . 

I do not receive brk event via minicom, break counter sets to 1 only if I issue
this command: stty -F /dev/ttyAT3 brkint 

Anyway I try to debug further to locate the problem.

BR,
Ivan
