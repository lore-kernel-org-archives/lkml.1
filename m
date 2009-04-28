Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZD1QAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZD1QAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761902AbZD1QAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:00:17 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:42695 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211AbZD1QAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:00:16 -0400
Date: Tue, 28 Apr 2009 18:03:17 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Eddie Dawydiuk <eddie@embeddedarm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Marvell 88F6281 Reference design
Message-ID: <20090428160316.GK14729@mail.wantstofly.org>
References: <49F7280C.5060709@embeddedarm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F7280C.5060709@embeddedarm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:00:12AM -0700, Eddie Dawydiuk wrote:

> Hello,

Hi,


> I have a Marvell 88F6281 Reference design board I'm trying to compile a 
> 2.6.28 kernel for. Although, the machine id check is failing. The error is 
> as follows
> 
> Uncompressing 
> Linux.............................................................................................................................
> . done, booting the kernel.
> 
> Error: unrecognized/unsupported machine ID (r1 = 0x0000020f).
> 
> Available machine support:
> 
> ID (hex)        NAME
> 00000690        Marvell DB-88F6281-BP Development Board
> 00000691        Marvell RD-88F6192-NAS Development Board
> 00000692        Marvell RD-88F6281 Reference Board
> 
> Please check your kernel config and/or bootloader.

This is because the boot loader passes in the wrong machine ID.

If you have the u-boot "arcNumber" parameter, try setting that to
the correct machine ID before booting the kernel.  Otherwise, you
can prepend a bit of code to the zImage that sets the machine ID to
the right value, e.g. for the 6281 RD:

	(echo -en "\x06\x1c\xa0\xe3\x92\x10\x81\xe3"; cat zImage) > zImage.rd88f6281

and then use mkimage on zImage.rd88f6281 to create a uImage that you
can boot on the board.
