Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYBROMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYBROMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYBROMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:12:24 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57815 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYBROMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:12:23 -0500
Date: Mon, 18 Feb 2008 23:12:43 +0900 (JST)
Message-Id: <20080218.231243.41197917.anemo@mba.ocn.ne.jp>
To: hskinnemoen@atmel.com
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
References: <20080216.223252.25909396.anemo@mba.ocn.ne.jp>
	<20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 12:42:37 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > Here is my quick workaround for this problem.  It makes all CSRn.CPOL
> > match for the transfer before activating chipselect.  I'm not quite
> > sure my analysis is correct, and there might be better solution.
> > Could you give me any comments?
> 
> I'm not sure if I fully understand what problem you're seeing. Is the
> clock state wrong when the chip select is activated?

Yes.

> If so, does the patch below help?

Hmm... It might fix my problem.  But IIRC the clock state follows
CSRn.CPOL just before the real transfer.  Like this (previous transfer
was MODE 0, new transfer is MODE 3):

           T0                T1 T2

CS      ~~~|________________________________________________

CLK     ______________________|~|___|~~~|___|~~~|___|~~~|___

SO      ~~~~~~~~~~~~~~~~~~~~~~~~~~|___|~~~|___|~~~|___|~~~|_
                                   MSB

T0-T1 was relatively longer then T1-T2.  I suppose T1 is not the
point of updating MR register, but the point of starting DMA transfer.

Anyway, I will try your patch in a few days.

---
Atsushi Nemoto
