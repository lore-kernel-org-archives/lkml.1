Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZJPNl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZJPNl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbZJPNl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:41:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:35060 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759434AbZJPNl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:41:28 -0400
Date: Fri, 16 Oct 2009 09:40:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jean Delvare <khali@linux-fr.org>
cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
    DP55KG motherboard? (chip ID: 0xb473)
In-Reply-To: <20091016125353.1c8795f4@hyperion.delvare>
Message-ID: <alpine.DEB.2.00.0910160838500.31450@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan> <alpine.DEB.2.00.0910140403150.15961@p34.internal.lan> <alpine.DEB.2.00.0910140856190.19307@p34.internal.lan> <20091015100557.22243433@hyperion.delvare> <alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
 <20091016111504.5d9cb0ba@hyperion.delvare> <alpine.DEB.2.00.0910160553221.2841@p34.internal.lan> <20091016125353.1c8795f4@hyperion.delvare>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Oct 2009, Jean Delvare wrote:

> On Fri, 16 Oct 2009 05:54:10 -0400 (EDT), Justin Piszcz wrote:
>> # ./sensors-detect
>> # sensors-detect revision 5782 (2009-10-16 10:59:16 +0200)
>> Trying family `VIA/Winbond/Nuvoton/Fintek'...               Yes
>> Found `Nuvoton W83677HG-I Super IO Sensors'
>>      (but no address specified)
>
> So the LPC interface to the hardware monitoring chip is disabled.
>
>> Probing for `Winbond W83791SD'...                           No
>
> You have an unknown chip at 0x2c on the SMBus. It could be a hardware
> monitoring chip... or not.
Ok..

>
> If you want me to investigate this, you can provide an I2C dump of the
> chip. Get i2cdump from the i2c-tools package, and then:
>
> # i2cdump 0 0x2c b
>
> This might confuse the chip in question though, so only try it if you
> are ready to trigger a cold reboot.

Ok, luckily it does not appear to have caused any issues:

# i2cdump 0 0x2c b
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-0, address 0x2c, mode byte
Continue? [Y/n] y
      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
10: 00 00 00 00 00 00 00 00 00 00 80 80 80 04 7e 10    ..........????~?
20: 75 51 c0 c3 c3 80 28 2d bd 0f de 0f 3b 1d a9 16    uQ????(-????;???
30: 33 4d 4d c2 81 00 c2 00 ff ff ff e6 7b fb 41 6f    3MM??.?....?{?Ao
40: 35 90 40 00 00 ff 00 ff 00 ff 00 ff 00 ff 81 7f    5?@...........??
50: 81 7f 81 7f ff ff ff ff ff ff ff ff 0a a2 a2 ca    ????........????
60: 8a 8a e0 aa 33 4c 4c 5a 2d 2d 64 41 41 04 42 00    ????3LLZ--dAA?B.
70: 00 00 00 00 00 00 6c 60 f0 00 00 55 01 00 00 00    ......l`?..U?...
80: 00 00 00 00 00 00 ff ff 00 00 fb 64 64 64 00 00    ..........?ddd..
90: 00 59 59 59 00 00 00 00 00 00 00 00 00 00 00 00    .YYY............
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
#


>
>> Client found at address 0x2d
>> (...)
>> Probing for `Winbond W83627DHG'...                          Success!
>>      (confidence 8, driver `use-isa-instead')
>
> This is the SMBus access to the W83677HG. We don't have support for
> that, because LPC access is faster and was always enabled on all
> motherboards we've seen so far.
Ok..

>
> I doubt we'll ever add SMBus access support, for both performance and
> source code readability reasons. If anything, we could forcibly enable
> the device on your motherboard. But please first look for BIOS options
> and/or a BIOS update to enable the LPC interface.
I am checking now...yes all HW monitoring/etc IS enabled.

>
> Do you see any hardware monitoring information in the BIOS?
Yep, see note above.  It is enabled.

>
> -- 
> Jean Delvare
> http://khali.linux-fr.org/wishlist.html
>
