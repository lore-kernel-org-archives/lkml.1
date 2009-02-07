Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZBGXh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZBGXh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZBGXhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:37:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:45574 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753615AbZBGXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:37:49 -0500
Message-ID: <498E1B46.2040500@ru.mvista.com>
Date: Sun, 08 Feb 2009 02:37:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: bzolnier@gmail.com, geert@linux-m68k.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
References: <498B7D09.6040100@ru.mvista.com>	<200902061721.46813.bzolnier@gmail.com>	<498CB3CF.8070306@ru.mvista.com> <20090208.003536.72707389.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090208.003536.72707389.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Atsushi Nemoto wrote:

>>> config CONFIG_IDE_BE_IO
>>> 	bool
>>>       
>>     If it was that simple... Normally the BE case gets handled automagically 
>> (moreover, there is MIPS option that additionally controls I/O and memory 
>> space byte swapping). The case we have to address for TX493x is actually where 
>> the usual magic fails (or actually the code just doesn't want to use that 
>> option). So this doesn't look like a good name to me...
>>     
>
> Well, for TX493x (MIPS), we have CONFIG_SWAP_IO_SPACE for big endian
> and it works fine for PCI-IDE host controllers.  For SoC internal
> controllers, no swapping is needed for both endian, thus custom tp_ops
> is needed only for big endian.
>   

   Yeah, SoCs *typically* can handle different endianness for the 
integrated devices in a transparent way. TX4939 didn't do that 
consistently still, and that's where the MIPS address swizzling macros 
could have helped but Atsushi chose to reserve their usage only to the 
external bus accesses. I however don't think that TX4938 case should 
have been handled the same way as TX4939 since in this case the 
controller is *not* SoC integrated device and the IDE registers are 
situated on the chip's external bus with their mapping is actually board 
specific, if I don't mistake (I don't have the datasheet at hand).

> So ... IDE_BE_IO looks actually not best name for this case.  It is
> IDE_RAW_IO or something.

   Yes, I was going to suggest exactly that.

> But IDE_RAW_IO might not fit for other cases.  IDE_SWAPPED_IO?

   I'd prefer IDE_RAW_IO because it can be swapped when using the 
standard accessors as well. Frankly speaking, I'm not sure why ide-h8300 
needs its own accessors while this arch's io.h has an abundance of 
swapping and not swapping accessors already defined...

> Any other good name?
>   

   I'm still not convinced that it's really worth the trouble...

> ---
> Atsushi Nemoto
>   

MBR, Sergei


