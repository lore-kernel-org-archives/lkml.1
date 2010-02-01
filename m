Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0BAW1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:27:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42521 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0BAW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:27:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B675534.5070107@s5r6.in-berlin.de>
Date: Mon, 01 Feb 2010 23:27:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com>
In-Reply-To: <4B6740B5.5070601@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> (as for yesterdays 0xffffffffffffffff(just experimenting)Google gives me
> no info on the differences between 8f's to 16f's, I was under the
> impression that it's x86_32 and x86_64 for the pci address).

As Dan noted,
	(class == 0xffffffff || 0xffffffffffffffff)
is always true because it is logically the same as
	(class == whatever) || true

If you really meant
	class == 0xffffffff || class == 0xffffffffffffffff
then the latter half will never become true because class is declared as
u32 and got its value from read_pci_config() which also returns u32.

BTW, whether a PCI device is capable of accessing 32 bit bus addresses
or also 64 bit bus addresses depends on the device, not on the CPU.
Originally, PCI only had a 32 bit addressing model.  OHCI 1394 1.0/1.1
implementations only deal with 32 bit local bus addresses.

The 'class' however is not an address but merely a register value with
24 bits width.  (Defined in the PCI Local Bus spec which is not freely
available, cited in OHCI 1394 annex A.3.)  This register is read as a 32
bits wide register from which the excess byte is later discarded.  If
all bits read are 1, the bus:slot:function is not actually populated.
-- 
Stefan Richter
-=====-==-=- --=- ----=
http://arcgraph.de/sr/
