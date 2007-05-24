Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXEXKvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXEXKvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXEXKvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:51:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:48009 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755547AbXEXKvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:51:37 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX182B+h3wng2b70LW1HuX86R0i3Bn0aY8FDDycN08p
	KHuP6odh0BRnIq
Message-ID: <46556E3A.5090005@gmx.de>
Date: Thu, 24 May 2007 12:51:38 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <4648E4A4.60309@imap.cc>
In-Reply-To: <4648E4A4.60309@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------080905060607000705000905"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------080905060607000705000905
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tilman Schmidt schrieb:
> Am 14.05.2007 15:00 schrieb Lars K.W. Gohlke:
>> after searching the mailing list and searching the web, I still don't
>> know how to access correctly the serial port (in user space known as
>> /dev/ttyS01)
>
> I can only tell you how I did it in the special case of the
> ser_gigaset driver which drives an ISDN device attached to
> a serial port: I implemented it as a line discipline which
> is associated to the appropriate serial port by a userspace
> daemon.
>
> Reading material:
>
> Documentation/tty.txt
> 	documentation on the line discipline interface
> include/linux/tty.h
> include/linux/tty_ldisc.h
> 	definitions for same
> drivers/isdn/gigaset/ser-gigaset.c
> 	my code - a simple example of abusing the line
> 	discipline interface for your own ends :-)
>
>> would somebody be so kind to give me an example:
>
> I hope the following will help you some. If not, feel free to
> ask again.
>
>> with this behaviour:
>>
>> 1. read from port
>
> That's not how things work in the kernel. There is no system
> call for reading some data that has arrived on that port or
> blocking if there is none, like a userspace program would do.
> Instead, when you register your line discipline you provide
> a callback function (receive_buf) for the serial driver to
> call when data has been received. That function can be called
> at any time and has to deal with the data as it gets it.
>
>> 2. output via printk()
>
> You can of course put a printk() in your receive_buf function.
> But ultimately you'll want to do more than that with the data,
> I'm sure.
>
>> 3. write to port
>
> That's easy. :-) No, it isn't. The serial driver *does*
> provide a function (aptly called "write") for sending data
> to the serial port, but you can't just call it any time you
> like. You have to synchronize with the driver by waiting for
> it to call your "write_wakeup" callback before you can call
> its write function again.
>
> HTH
> T.
>

I read you piece of code but it is overkill for me, I dont not see the
wood for the trees.

Many lines I'm recognizing as things I have read about kernel in my
book, but far away from understanding.

Anyway thx.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGVW47AAomYJ1taN8RAuccAJ9TIvocrrVFCwcxnFsZZo8cLxLgKACglwD3
/zudmDgwvWo/5St0zC0UnHI=
=1Qgs
-----END PGP SIGNATURE-----

--------------080905060607000705000905
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


--------------080905060607000705000905--

