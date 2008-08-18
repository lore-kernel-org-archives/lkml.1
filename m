Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYHRSYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYHRSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYHRSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:24:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46445 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbYHRSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:24:03 -0400
Date: Mon, 18 Aug 2008 19:06:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Matt_Domsch@dell.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long
 Physical Sectors
Message-ID: <20080818190629.22fd618c@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818181523.GG677@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	<1217957207-23116-3-git-send-email-matthew@wil.cx>
	<48A8B211.8030103@pobox.com>
	<20080818181523.GG677@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	static const char command_sect_size[256] = {
> +		[ ATA_CMD_CFA_TRANSLATE_SECTOR ] = DEVICE,

Should be a bit array so we can do a single fast test_bit()

> +	if (size == UNKNOWN && printk_ratelimit())
> +		printk("Unknown ata cmd %d, assuming 512 byte sector size\n",
> +				command);

or two bits ;)


Rest looks ok. I'll probably send a follow up patch to make most pata
drivers return "no" to anything but 512 until we can test them with real
devices.

Alan
