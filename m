Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYFMEIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYFMEIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYFMEIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:08:07 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:39067 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706AbYFMEIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:08:05 -0400
Date: Fri, 13 Jun 2008 01:06:34 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080613040634.GA3281@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806112021.50264.IvDoorn@gmail.com> <20080612042320.GB19980@ime.usp.br> <200806121940.28882.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806121940.28882.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 9754c7f9375c15fb56471be0edb51523
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Ivo.

I finally found a x86-64 (little-endian) where I could test the D-Link
stick.

On Jun 12 2008, Ivo van Doorn wrote:
> Unfortunately I haven't that much time to test it, and the
> allmodconfig kernel is still providing the same problems as my usual
> configuration.

Thanks quite unfortunate. For me, I can't make -rc5 associate with the
AP, which is a regression regarding -rc4. With -rc4, on this x86-64
machine, at least I could associate and everything looked fine, but like
with the iBook, I can't get a dhcp lease from the AP. :-(

(BTW, I think that I can do some sessions of "git bisect" to find which
patch has modified this behavior).

I compiled the kernel with debugfs, like you instructed me and got a
register dump of the kernel on this machine and looking at it, there
seems to have some endianness things going on, but I am not qualified to
say anything about this.

> I am a bit closer at tracking this down, but I won't have another shot
> at this before the weekend :S

:-(

Well, I'm attaching the diff between the regdump from the earlier try on
the iBook and the regdump from this x86-64. I think that some
conclusions may be drawn from it, since it seems to be your domain of
expertise.


Thanks, Rogério Brito.

P.S.: If John can say something that you would like me to try, I will do
my best.
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="diff-regdump.txt"

--- output-regdump.txt	2008-06-13 00:52:11.000000000 -0300
+++ regdump-x86-64.txt	2008-06-13 00:31:32.000000000 -0300
@@ -1,7 +1,7 @@
-2.6.26-rc5-2
+2.6.26-rc4-1
 driver: rt2500usb
 version: 2.1.4
-compiled: Jun  8 2008 17:08:54
+compiled: Jun 13 2008 00:11:03
 dev_flags: 0x00000e2f
 rt chip: 1201
 rf chip: 0005
@@ -13,29 +13,29 @@
 rf length: 5
 
 csr
-0 :0x00050000
-1 :0x00040000
-2 :0x13000000
-3 :0xe9460000
-4 :0x8a8d0000
-5 :0x13000000
-6 :0x51460000
-7 :0x65100000
-8 :0x09800000
-9 :0xff1d0000
-10 :0x00140000
-11 :0x000a0000
-12 :0x013a0000
-13 :0x11110000
-14 :0x1e110000
-15 :0x01ee0000
+0 :0x00000005
+1 :0x00000004
+2 :0x00001300
+3 :0x0000e946
+4 :0x00008a8d
+5 :0x00001300
+6 :0x00005146
+7 :0x00006510
+8 :0x00000980
+9 :0x0000ff1d
+10 :0x00000014
+11 :0x0000000a
+12 :0x0000013a
+13 :0x00001111
+14 :0x00001e11
+15 :0x000001ee
 16 :0x00000000
-17 :0x01fe0000
-18 :0x005a0000
-19 :0xff000000
-20 :0x00020000
-21 :0x1e460000
-22 :0x00530000
+17 :0x000001fe
+18 :0x0000005a
+19 :0x0000ff00
+20 :0x00000002
+21 :0x00001e46
+22 :0x00000053
 23 :0x00000000
 24 :0x00000000
 25 :0x00000000
@@ -45,28 +45,28 @@
 29 :0x00000000
 30 :0x00000000
 31 :0x00000000
-32 :0x1ec00000
-33 :0xb1620000
-34 :0x007e0000
-35 :0xb3af0000
-36 :0xb3aa0000
-37 :0x8c8d0000
-38 :0x8b8a0000
-39 :0x86870000
-40 :0x00850000
-41 :0x01620000
-42 :0x000a0000
+32 :0x00001ec0
+33 :0x0000b162
+34 :0x0000007e
+35 :0x0000b3af
+36 :0x0000b3aa
+37 :0x00008c8d
+38 :0x00008b8a
+39 :0x00008687
+40 :0x00000085
+41 :0x00000162
+42 :0x0000000a
 43 :0x00000000
-44 :0x140a0000
-45 :0x70380000
-46 :0x0c130000
-47 :0x06090000
-48 :0x03050000
-49 :0x02030000
-50 :0xfa000000
-51 :0x000b0000
-52 :0x00030000
-53 :0xe78f0000
+44 :0x0000140a
+45 :0x00007038
+46 :0x00000c13
+47 :0x00000609
+48 :0x00000305
+49 :0x00000203
+50 :0x0000fa00
+51 :0x0000000b
+52 :0x00000003
+53 :0x0000e78f
 54 :0x00000000
 55 :0x00000000
 56 :0x00000000
@@ -109,38 +109,38 @@
 93 :0x00000000
 94 :0x00000000
 95 :0x00000000
-96 :0x12210000
-97 :0x00030000
+96 :0x00001221
+97 :0x00000003
 98 :0x00000000
 99 :0x00000000
-100 :0x000f0000
-101 :0x82060000
-102 :0x821e0000
-103 :0x91000000
+100 :0x0000000f
+101 :0x00008206
+102 :0x0000821e
+103 :0x00009100
 104 :0x00000000
-105 :0x0e070000
-106 :0x54000000
+105 :0x00000e07
+106 :0x00005400
 107 :0x00000000
 108 :0x00000000
 109 :0x00000000
 110 :0x00000000
 111 :0x00000000
-112 :0x032c0000
-113 :0xfb580000
-114 :0x63110000
-115 :0x0a1f0000
+112 :0x000000ad
+113 :0x00009bcf
+114 :0x0000186c
+115 :0x000002e8
 116 :0x00000000
 117 :0x00000000
 118 :0x00000000
 119 :0x00000000
 120 :0x00000000
 121 :0x00000000
-122 :0x02e10000
+122 :0x0000009c
 123 :0x00000000
 124 :0x00000000
 125 :0x00000000
 126 :0x00000000
-127 :0x00000422
+127 :0x00000000
 
 eeprom
 0 :0x2570
@@ -199,7 +199,7 @@
 
 bbp
 0 :0x13
-1 :0x55
+1 :0x63
 2 :0x06
 3 :0x02
 4 :0x19
@@ -211,7 +211,7 @@
 10 :0x00
 11 :0x04
 12 :0x01
-13 :0xa8
+13 :0x70
 14 :0x1a
 15 :0x30
 16 :0xac
@@ -227,7 +227,7 @@
 26 :0x08
 27 :0x23
 28 :0x18
-29 :0x18
+29 :0x6e
 30 :0x10
 31 :0x2b
 32 :0xb9
@@ -240,20 +240,20 @@
 39 :0xc4
 40 :0x02
 41 :0x60
-42 :0x09
-43 :0x34
-44 :0x0b
-45 :0x6e
-46 :0x70
+42 :0x0f
+43 :0x0f
+44 :0x16
+45 :0x65
+46 :0xeb
 47 :0x0a
 48 :0x04
-49 :0x02
-50 :0x68
-51 :0x18
-52 :0x04
+49 :0x03
+50 :0xf8
+51 :0x1d
+52 :0x2e
 53 :0x10
 54 :0x18
-55 :0x2d
+55 :0x7d
 56 :0x08
 57 :0x10
 58 :0x08

--0OAP2g/MAC+5xKAE--
