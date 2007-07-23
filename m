Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbXGWWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbXGWWfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXGWWey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:34:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXGWWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:34:53 -0400
Message-ID: <46A52D05.4050603@zytor.com>
Date: Mon, 23 Jul 2007 15:34:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc1] APM detection logic bug fix
References: <200707232225.l6NMPxrq009114@harpo.it.uu.se>
In-Reply-To: <200707232225.l6NMPxrq009114@harpo.it.uu.se>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Starting with kernel 2.6.23-rc1, the i386 APM driver fails
> on several of my machines with the message:
> 
> apm: BIOS not found
> 
> This happens because of a bug in the i386 boot code rewrite
> from assembler to C. The original assembly code had the
> following code in its APM BIOS presence test (boot/setup.S):
> 
> 	andw	$0x02, %cx			# Is 32 bit supported?
> 	je	done_apm_bios			# No 32-bit, no (good) APM BIOS
> 
> That is, the code bails out if bit 2 is zero.
> 
> In the new C version, this is coded as (boot/apm.c):
> 
> 	if (cx & 0x02)		/* 32 bits supported? */
> 		return -1;
> 
> Here we see that the test has been accidentally inverted.
> 
> The fix is to negate the test. I've verified that this
> allows the APM driver to work again on my affected machines.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> 

Thanks, applied.

	-hpa
