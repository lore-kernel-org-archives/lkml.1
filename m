Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbXJETr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbXJETr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXJETru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:47:50 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:49125 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057AbXJETrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:47:49 -0400
Message-ID: <470694E0.7030408@freescale.com>
Date: Fri, 05 Oct 2007 14:47:44 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> Bit representation is left to the CPU, so 1 << 1 will always be 2,
> regardless of whether the byte, when sent out to the network,
> is 01000000 or 00000010. Endianess becomes important as soon
> as the packet is on the network, of course.

Well yes, that's why I'm asking.  I'm not concerned about data from just the 
CPU's perspective.

I'm writing a driver that talks to hardware that has a shift register.  The 
register can be shifted either left or right, so all the bits obviously have 
to be in order, but it can be either order.

What I want to do is to have the driver detect when byte-endianness doesn't 
match bit-endianness when it writes the the word to a memory-mapped device.  I 
think I can do that like this:

#if (defined(LITTLE_ENDIAN) && defined(BIG_ENDIAN_BITFIELD)) || 
(defined(BIG_ENDIAN) && defined(LITTLE_ENDIAN_BITFIELD))
#error "This CPU architecture is not supported"
#endif

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
