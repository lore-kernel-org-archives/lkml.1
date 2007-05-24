Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbXEXTPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbXEXTPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXEXTPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:15:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:34388 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750794AbXEXTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:15:47 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19V4HQGvx9V+HNUnV2BQDWzetjS+jpw5JkJZiUe6Q
	rriNcX29JuRh6g
Message-ID: <4655E463.7000201@gmx.de>
Date: Thu, 24 May 2007 21:15:47 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de> <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr>
Content-Type: multipart/mixed;
 boundary="------------050604060108030806020902"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------050604060108030806020902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan Engelhardt schrieb:
> On May 24 2007 19:19, Lars K.W. Gohlke wrote:
>> I want to read from serial port (I mean the port, which is called
>> /dev/ttyS0 in user-space). Then I want copy_to_user() it through
>> /proc/serialPort
>>
>> This is just to get familiar with driver programming (in kernelspace),
>> it could be better done in userspace - I know. But this is for learning.
>>
>> It is a kind of synthetic problem, but after this, I hope too know how
>> to handle further ones.
>>
>> Understood? It is a little bit strange, but hope it is explained well. ;)
>>
>> If tell me that for /dev/ttyS0 I can adept it to /dev/ttyS1 etc..
>
>
> struct file *filp = filp_open("/dev/ttyS0");
> char buf[4096];
> mm_segment_t oldfs = get_fs();
> loff_t pos = 0;
>
> set_ds(KERNEL_DS);
> while (vfs_read(filp, buf, sizeof(buf), &pos) > 0)
> 	printk("%s\n", buf);
>
> filp_close(filp);
>
>
>
> [I've warned about it... ;-) ]
>
> 	Jan
is it the way to access from kernelspace the userspace fs?
the not-correct-way?

If it is so, I will wait for another solution ;)

Dont want to learn writing nasty kernel code. *g*

Anyway thx.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGVeRlAAomYJ1taN8RAj4LAJ4oD+3yGy6k69nBEXi5BSda+tdeNACeOCTY
+nJSUcsGpwh25uDjyC2GKRU=
=twVz
-----END PGP SIGNATURE-----

--------------050604060108030806020902
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


--------------050604060108030806020902--

