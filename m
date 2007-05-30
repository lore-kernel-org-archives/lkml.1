Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbXE3Hq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbXE3Hq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXE3Hqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:46:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:44252 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750825AbXE3Hqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:46:51 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX1/ovy8EnE/oww5+4rgy+r70Ry95KpgCiojNDFdGdE
	8BP4Pm9yz5XjLI
Message-ID: <465D2BEC.2090008@gmx.de>
Date: Wed, 30 May 2007 09:46:52 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de> <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr> <4655E463.7000201@gmx.de> <465B0BC9.2040502@imap.cc> <465D22A6.4090107@gmx.de>
In-Reply-To: <465D22A6.4090107@gmx.de>
Content-Type: multipart/mixed;
 boundary="------------010702010701070101090704"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------010702010701070101090704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Lars K.W. Gohlke schrieb:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Tilman Schmidt schrieb:
>> Am 24.05.2007 21:15 schrieb Lars K.W. Gohlke:
>>> Jan Engelhardt schrieb:
>> [code proposal]
>>>> [I've warned about it... ;-) ]
>>> is it the way to access from kernelspace the userspace fs?
>>> the not-correct-way?
>>
>> Yes, indeed.
>>
>>> If it is so, I will wait for another solution ;)
>>
>> I'm not sure waiting will help. The roasted pigeons will not come
>> flying into your mouth.
>>
>> The possible solutions have been sketched out for you:
>>
>> a) open the device file from the kernel (described by Jan):
>>    actively discouraged by the kernelnewbies.org FAQ document,
>>    and probably won't even work IMHO
>>
>> b) program the serial port directly (described by Jan):
>>    will work only with one type of hardware and you'll have to
>>    disable the regular serial driver first; frowned upon by kernel
>>    gurus as "reinventing the wheel"
>>
>> c) abuse the line discipline interface (described by me):
>>    moderately well documented, and there's precedent for using it
>>    that way in the well-accepted PPP module as well as my humble
>>    contribution, the ser_gigaset driver; requires a userspace
>>    daemon for pushing the line discipline module on the serial
>>    port and keeping it there
>>
>> d) use the serio interface (described by Ying Huang):
>>    potentially cleaner conceptually and seems to work without a
>>    userspace daemon, but apparently not documented anywhere
>>    except in the source files drivers/input/serio/serport.c
>>    and linux/drivers/input/mouse/sermouse.c
>>
>> Now it's your turn to decide.
>>
>> HTH
>> T.
>>
>
> When I'm chosing option d) can smb. help me step by step? There are so
> many pieces of code I don't understand.
>
> Ok, let's begin:
>
> my kernel source base is : ubuntu-lts 6.06 and 2.6.15-7
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.15.y.git;a=tree;f=drivers/input/serio;
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959
>
> iD8DBQFGXSKoAAomYJ1taN8RApggAJ99t+yMvPScr4yhOoTOS9TvYVUMsgCeJAbI
> nGTvFGb49gUOzJG17Nmypq4=
> =K4W8
> -----END PGP SIGNATURE-----


[linux/drivers/input/mouse/sermouse.c]

Where can I see, which serial line is used to get data stream from?

The mouse is plugged in. Where is the decision made, that maybe port0 is
  used?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGXSvtAAomYJ1taN8RAjYtAKDfYqyK//u96/sxWMdLuUfRtMi2XwCg031C
lfEog7wFwd280dJeoqEZvu4=
=AH3F
-----END PGP SIGNATURE-----

--------------010702010701070101090704
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lkwg82.vcf"

begin:vcard
fn:Lars K.W. Gohlke
n:Gohlke;Lars K.W.
email;internet:lkwg82@gmx.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------010702010701070101090704--

