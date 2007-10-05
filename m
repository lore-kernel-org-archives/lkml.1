Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbXJEVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbXJEVKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763041AbXJEVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:10:34 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:39830 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761765AbXJEVKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:10:33 -0400
Message-ID: <4706A842.9030507@freescale.com>
Date: Fri, 05 Oct 2007 16:10:26 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
In-Reply-To: <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Altaparmakov wrote:

>> ---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
>> L234567M L234567M L234567M L234567M  [bits] LITTLE_ENDIAN_BITFIELD
> 
> No it is not.  That makes no sense. 

Why not?  I honestly don't know what x86 does, but I would think that if I 
write a 32-bit value to a memory location, that when I examine that memory 
location, all 32 bits will be in order.

> The whole point of little endian is 
> that you store LSB, then 2SB, then 3SB, then MSB and then when the CPU 

You're talking about byte endian.  I'm talking about bit endian -- the order 
of bits within a byte.  Software cannot know what the bit endian is, but 
external devices that have memory-mapped registers can know.

> reads this as a 32-bit word it rotates them all around so that in the 
> CPU register you have:
> 
> MSB_3SB_2SB_LSB
> M765432L_M765432L_M765432L_M765432L
> 
> That is what little endian means and that is how shift operations can 
> work fine on the CPU.

The CPU shift operation, yes.  I'm talking about shift operations on external 
memory-mapped devices.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
