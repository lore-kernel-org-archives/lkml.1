Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXJEUiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXJEUiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764219AbXJEUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:37:53 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:63527 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763271AbXJEUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:37:52 -0400
Message-ID: <4706A096.4000700@freescale.com>
Date: Fri, 05 Oct 2007 15:37:42 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Andreas Schwab <schwab@suse.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr> <470694E0.7030408@freescale.com> <jed4vtnxa5.fsf@sykes.suse.de> <47069982.9030009@freescale.com> <Pine.LNX.4.61.0710051623060.29533@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0710051623060.29533@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:

> It makes no sense because a bitfield is something having to
> do with a 'C' compiler and it must NEVER be used as a template
> to address hardware! 'C' gives no guarantee of the ordering
> within machine words. The only way you can access them is
> using 'C'. They don't have addresses like other objects
> (of course they do exist --somewhere). They are put into
> "storage units," according to the standard, and these
> storage units are otherwise undefined although you can
> align them (don't go there).

Well, if it doesn't make any sense why do we have __LITTLE_ENDIAN_BITFIELD and 
__BIG_ENDIAN_BITFIELD?  That is, why do we do this:

#if defined(__BIG_ENDIAN_BITFIELD)
	__u8 reserved1		: 2;
	__u8 ili		: 1;
	__u8 reserved2		: 1;
	__u8 sense_key		: 4;
#elif defined(__LITTLE_ENDIAN_BITFIELD)
	__u8 sense_key		: 4;
	__u8 reserved2		: 1;
	__u8 ili		: 1;
	__u8 reserved1		: 2;
#endif

when we can just do this:

#if defined(__BIG_ENDIAN)
	__u8 reserved1		: 2;
	__u8 ili		: 1;
	__u8 reserved2		: 1;
	__u8 sense_key		: 4;
#elif defined(__LITTLE_ENDIAN)
	__u8 sense_key		: 4;
	__u8 reserved2		: 1;
	__u8 ili		: 1;
	__u8 reserved1		: 2;
#endif

> If you want to call machine-control bits by name, just
> define them as hexadecimal numbers (unsigned ints) and,
> if your hardware is for both little/big endian, use
> a macro that resolves the issue between the number
> and the hardware.

That wasn't my intention.  I was hoping that __LITTLE_ENDIAN_BITFIELD could be 
used to test bit-endianness, but I guess it can't.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
