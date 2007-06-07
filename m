Return-Path: <linux-kernel-owner+w=401wt.eu-S937612AbXFGWZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937612AbXFGWZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937525AbXFGWZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:25:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:60376 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S937499AbXFGWZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:25:17 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19KtXYUZtRKBYFPOzIPp3OVUVAFAtS1Z7QufvTI0D
	fVj2CZomt02cOR
Message-ID: <466885CB.4070702@gmx.de>
Date: Fri, 08 Jun 2007 00:25:15 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com> <465366CB.7090608@imap.cc> <46632489.9070107@gmx.de> <4665D89E.8080408@imap.cc> <46666FD8.9010702@gmx.de>
In-Reply-To: <46666FD8.9010702@gmx.de>
Content-Type: multipart/mixed;
 boundary="------------050300090501050003010109"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------050300090501050003010109
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Lars K.W. Gohlke schrieb:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Tilman Schmidt schrieb:
>> Am 03.06.2007 22:28 schrieb Lars K.W. Gohlke:
>>> Tilman Schmidt schrieb:
>>>> Am 17.05.2007 08:15 schrieb huang ying:
>>>>> I think the "serio" (through =
drivers/input/serio/serport.c) may be a
>>>>> choice too, like that in =
linux/drivers/input/mouse/sermouse.c, which
>>>>> is an example to program serial port in kernel space.
>>>> Interesting. I wonder if that would have been a better =
choice for
>>>> the Gigaset M101 driver. It seems even to have a probe =
mechanism
>>>> so one could try to determine if the expected device is =
really
>>>> connected to the port.
>>>> Is there any documentation on this interface? I find the =
source a
>>>> bit hard to understand, sparsely commented as it is.
>>> how can I open ttyS1 with major=3D4 and minor=3D65?
>>
>> a) With "my" approach, ie. writing a line discipline, you =
open
>> /dev/ttyS1 in a user space program and then push your line =
discipline
>> onto it using ioctl(,TIOCSETD,).
>>
>> b) With the "serio" approach, if the probe mechanism is =
really what
>> I think it is, you register your probe function and wait for=
 it to
>> be called for each active serial port, then do your thing to=
 determine
>> whether this is a/the port you want to use.
>>
>>> Does anybody have some code to read from it the first e.g. =
2bytes?
>>
>> That's not how things work in the kernel. You don't "read =
the first
>> <n> bytes" at will. You have to provide means to process =
whatever
>> data happens to arrive on the serial port, as it arrives.
>>
>> a) With a line discipline, you provide a callback function
>> ".receive_buf" which will be called by the serial driver if =
some
>> data has been received, and has to process that data then =
and there.
>> You might just stow it away in a buffer of course, provided =
you
>> are sure to get around to processing it later.
>>
>> b) With the "serio" interface, it seems the ".interrupt" =
function
>> serves the same purpose - though, as I said, I am not really
>> competent on that topic.
>>
>> HTH
>> T.
>>
> ok because I want to handle it in kernel space I will no take=
 option a)
>
> I will try it the way of b)
>
> anyway thx.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959
>
> =
iD8DBQFGZm/aAAomYJ1taN8RAhS1AKC5xZVKXjZPAovXLmz2vuVr7JXssQCgqxs9
> PUcqGC5sTzPtEzxuc5nkdes=3D
> =3DqO4W
> -----END PGP SIGNATURE-----

I asked vojtech@suse.cz as one of the driver developer

this is how I did it (just prototype)

(neccessary just one folder and two files)
1. copy template linux-source/drivers/input/joystick/magellan.c
2. insert in line 90  :
	printk("%s:\"%s\"\n",__FUNCTION__, data);
3. make and insert it
4. inputattach --magellan /dev/ttyS0 &
5. date > /dev/ttyS0
6. dmesg | tail

voil=C3=A0!

[output von dmesg]

	[27336.486980] serio: Serial port ttyS0
	[27336.487270] input: LogiCad3D Magellan / SpaceMouse as
/class/input/input6 [27336.518603] magellan_process_packet:"Mi =
 6 Jun
19:22:31 CEST 2007"

[/output]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGaIXNAAomYJ1taN8RAhHiAKDXAu4a/rKVS+Loz1Pqzo3mjWvlWACfZJje
q241AnJqNDn8q6YxQRB9lUU=3D
=3DCBPt
-----END PGP SIGNATURE-----

--------------050300090501050003010109
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------050300090501050003010109--

