Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbXLQAHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbXLQAHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXLQAGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:06:52 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:62872 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757806AbXLQAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:06:50 -0500
X-Trace: 642633195-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.89.91
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAL5LZUdRAVlb/2dsb2JhbACBV6Y1
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20071216215929.GA14278@linux-sh.org>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
	 <20071216095019.GA12184@linux-sh.org>
	 <1197826371.6254.14.camel@localhost.localdomain>
	 <20071216215929.GA14278@linux-sh.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 00:06:23 +0000
Message-Id: <1197849983.1626.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-17 at 06:59 +0900, Paul Mundt wrote:

> 
> While I realize that this is all undocumented and based entirely on
> reverse engineering, you should at least verify that that's precisely
> what is going on, and that this is not just a precaution for flushing
> posted writes. You can test that by removing the loop and doing a dummy
> read after your write (to the same register, rather than the entire ROM
> space). If it's a posting issue, then you will have to do your own
> read/write_reg routines that handle the flush.


I've looked at this some more and, from the various things on the web,
it seems SEGA introduced some sort of crude checksum security feature
which ctrl_outl(0x1fffff, GDROM_RESET_REG) appears to start. Unless it
is used then the GD Rom remains disabled.

After that, the hardware executes a checksum of the ROM to ensure that
you are actually booting from a Dreamcast.

Well, that is my interpretation of
http://www.ludd.ltu.se/~jlo/dc/bootROM.c and similar. Certainly any
other sort of read seems to keep the gdrom disabled.


