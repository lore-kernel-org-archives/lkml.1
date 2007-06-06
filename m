Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXFFI1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXFFI1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXFFI1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:27:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:56148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752505AbXFFI1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:27:06 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX1+Swuc2eKWSwsaiaswq/C5HKIIDipoGTm9iutC31w
	EY55ETKlsh2VMR
Message-ID: <46666FD8.9010702@gmx.de>
Date: Wed, 06 Jun 2007 10:27:04 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com> <465366CB.7090608@imap.cc> <46632489.9070107@gmx.de> <4665D89E.8080408@imap.cc>
In-Reply-To: <4665D89E.8080408@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------080101050107000406010003"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------080101050107000406010003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tilman Schmidt schrieb:
> Am 03.06.2007 22:28 schrieb Lars K.W. Gohlke:
>> Tilman Schmidt schrieb:
>>> Am 17.05.2007 08:15 schrieb huang ying:
>>>> I think the "serio" (through drivers/input/serio/serport.c) may be a
>>>> choice too, like that in linux/drivers/input/mouse/sermouse.c, which
>>>> is an example to program serial port in kernel space.
>>> Interesting. I wonder if that would have been a better choice for
>>> the Gigaset M101 driver. It seems even to have a probe mechanism
>>> so one could try to determine if the expected device is really
>>> connected to the port.
>>> Is there any documentation on this interface? I find the source a
>>> bit hard to understand, sparsely commented as it is.
>> how can I open ttyS1 with major=4 and minor=65?
>
> a) With "my" approach, ie. writing a line discipline, you open
> /dev/ttyS1 in a user space program and then push your line discipline
> onto it using ioctl(,TIOCSETD,).
>
> b) With the "serio" approach, if the probe mechanism is really what
> I think it is, you register your probe function and wait for it to
> be called for each active serial port, then do your thing to determine
> whether this is a/the port you want to use.
>
>> Does anybody have some code to read from it the first e.g. 2bytes?
>
> That's not how things work in the kernel. You don't "read the first
> <n> bytes" at will. You have to provide means to process whatever
> data happens to arrive on the serial port, as it arrives.
>
> a) With a line discipline, you provide a callback function
> ".receive_buf" which will be called by the serial driver if some
> data has been received, and has to process that data then and there.
> You might just stow it away in a buffer of course, provided you
> are sure to get around to processing it later.
>
> b) With the "serio" interface, it seems the ".interrupt" function
> serves the same purpose - though, as I said, I am not really
> competent on that topic.
>
> HTH
> T.
>
ok because I want to handle it in kernel space I will no take option a)

I will try it the way of b)

anyway thx.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGZm/aAAomYJ1taN8RAhS1AKC5xZVKXjZPAovXLmz2vuVr7JXssQCgqxs9
PUcqGC5sTzPtEzxuc5nkdes=
=qO4W
-----END PGP SIGNATURE-----

--------------080101050107000406010003
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------080101050107000406010003--

