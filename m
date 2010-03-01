Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab0CAL4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:56:22 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:49897 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0CAL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gdWNyzimYtoCMo7Z/I2YTxJd2z9U/HaX24SyLlYdCWpZN2geybpEfskKBKXF8E0uUA
         W7vo9ftts3ou8wmoDPPJupi88ruyfFdDs99QfumRZWAXs2HUw+i54hIbQQ+9NbG0Q7Sk
         hMJmDGXfChH+ToLVfp2wZKQdXR8vDuAosA9ec=
Message-ID: <4B8BAB5C.5030707@gmail.com>
Date: Mon, 01 Mar 2010 22:56:12 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
 before decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>	 <4B80CA55.3040402@zytor.com> <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com> <4B88A865.2080009@gmail.com>
In-Reply-To: <4B88A865.2080009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> Graeme Russ wrote:
>> On Sun, Feb 21, 2010 at 4:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 02/20/2010 09:45 PM, H. Peter Anvin wrote:
>>>

> I borrowed __show_regs() from process_32.c and implemented crash dump and
> break dump handlers in u-boot. So now I can int3 and dump all registers.
> 
> 
> I don't understand what is going on with SS and ESP, but everything else is
> looking good up until:
>  	jmp	*%eax
> 
> At which point, eax appears to hold a reasonably value. But:
> 
> boot > md 5379c4
> 005379c4: c11c0e7f b0c2ea61 2d43c068 f02e6fa0    ....a...h.C-.o..

> I would have expected a 0xcc at 0x005379c4.
> 

I have done a little more digging. By adding an ascii string before
relocated: label, I am able to determine that the int3 after the relocated:
label exists in bzImage at offset 0x1C3FD7

EAX holds (for the jump) 0x5379d0 (different bzImage of course). The
contents of memory at this address is in bzImage at offset 0x1C09D7 - A
difference of 0x3600 (seems too even to be random)

I'm obviously doing something hideously wrong, but what?

Regards,

Graeme


