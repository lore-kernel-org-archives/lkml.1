Return-Path: <linux-kernel-owner+w=401wt.eu-S1763132AbXK2REz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763132AbXK2REz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXK2REl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:04:41 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:37201 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763417AbXK2REk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:04:40 -0500
Date: Thu, 29 Nov 2007 12:04:36 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, avuton@gmail.com, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mrmacman_g4@mac.com,
       dean@arctic.org, argggh@dolphinics.no, jengelh@computergmbh.de,
       shdl@zakalwe.fi, vlobanov@speakeasy.net, drzeus-list@drzeus.cx,
       strange@nsk.no-ip.org, dm.n9107@gmail.com, johannes@sipsolutions.net
Subject: Re: [RFC v2] Documentation about unaligned memory access
Message-ID: <20071129170436.GA2754@fattire.cabal.ca>
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129161523.E0C349D4B52@zog.reactivated.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Nov 29, 2007 at 04:15:23PM +0000, Daniel Drake wrote:
> Unaligned memory accesses occur when you try to read N bytes of data starting
> from an address that is not evenly divisible by N (i.e. addr % N != 0).
> For example, reading 4 bytes of data from address 0x10004 is fine, but
> reading 4 bytes of data from address 0x10005 would be an unaligned memory
> access.
> 

This is rather ambiguous, while most people know what you mean,
clarifying it a bit might be nice. How about something like,

Unaligned memory accesses occur when trying to read more than a byte
(i.e. u16, u32, u64) in a single instruction from an address that is not
evenly divisible by the width of the type (i.e. addr % width != 0).

For example, if you had 4GB of virtual memory, picture it as an
array of bytes,
	u8 memory[4096 * (1024 * 1024)];	/* 4G bytes */
Aligned accesses would be accessing this array in this manner,
	u16 memory[(4096 * (1024 * 1024)) / sizeof(u16)] /* 2G bytes */
	u32 memory[(4096 * (1024 * 1024)) / sizeof(u32)] /* 1G bytes */
	u64 memory[(4096 * (1024 * 1024)) / sizeof(u64)] /* 512M bytes */
And an unaligned access would be accessing on a non-integer multiple
boundary.

Ok, that kind of sucked too. But you get the idea.

> 
> Why unaligned access is bad
> ===========================
> 

The rest of this looks good.

Acked-by: Kyle McMartin <kyle@parisc-linux.org>

cheers,
	Kyle
