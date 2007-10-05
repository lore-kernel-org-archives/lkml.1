Return-Path: <linux-kernel-owner+w=401wt.eu-S1763919AbXJEVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763919AbXJEVGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJEVGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:06:05 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:41029 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXJEVGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:06:03 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <470691EB.7020209@freescale.com>
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Date: Fri, 5 Oct 2007 22:06:00 +0100
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Oct 2007, at 20:35, Timur Tabi wrote:
> Jan Engelhardt wrote:
>> On Oct 5 2007 13:27, Timur Tabi wrote:
>>> What's the difference between __LITTLE_ENDIAN and  
>>> __LITTLE_ENDIAN_BITFIELD? Can
>>> someone give me an example when __BIG_ENDIAN and  
>>> __LITTLE_ENDIAN_BITFIELD would
>>> both be defined simultaneously?
>> standard x86:
>> ---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
>> M765432L M765432L M765432L M765432L  [bits] ?_BITFIELD
>> (Not sure what bitfield type, but I'd guess BIG_ENDIAN_BITFIELD)
>
> Are you sure?  I would think that all machines would have the same  
> byte and bit endian, otherwise you'd never be able to put a 16-bit  
> value into a shift register.  Your bits will be shifted out like this:
>
> <-- 07 06 05 04 03 02 01 00 15 14 13 12 11 10 09 08
>
> So I think x86 is:
>
> ---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
> L234567M L234567M L234567M L234567M  [bits] LITTLE_ENDIAN_BITFIELD

No it is not.  That makes no sense.  The whole point of little endian  
is that you store LSB, then 2SB, then 3SB, then MSB and then when the  
CPU reads this as a 32-bit word it rotates them all around so that in  
the CPU register you have:

MSB_3SB_2SB_LSB
M765432L_M765432L_M765432L_M765432L

That is what little endian means and that is how shift operations can  
work fine on the CPU.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


