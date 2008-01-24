Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYAXXer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYAXXer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYAXXej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:34:39 -0500
Received: from dbs1.uni-c.dtu.dk ([130.225.88.6]:49843 "HELO dbs1.uni-c.dtu.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751691AbYAXXei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:34:38 -0500
From: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Date: Fri, 25 Jan 2008 00:34:36 +0100 (CET)
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
In-Reply-To: <47975F33.6040206@gmail.com>
Message-ID: <Pine.LNX.4.64.0801250013410.3424@dbs1.uni-c.dtu.dk>
References: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk>
 <479521F7.9050701@gmail.com> <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
 <47975F33.6040206@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511572392-399198121-1201217676=:3424"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511572392-399198121-1201217676=:3424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 23 Jan 2008, Jiri Slaby wrote:

> On 01/22/2008 11:23 AM, Oyvind Aabling wrote:
>> On Mon, 21 Jan 2008, Jiri Slaby wrote:
>>> Would you be willing to test such a patch for point no. 3?
>>=20
>> Yes, I could do that.
>>=20
>> I can see your point about the non-portability of it, but
>> how about this scenario, to provide backwards compatibility:
>>=20
>> * We keep the (ugly and non-compatible) MOXA_GET_CONF
>>   ioctl, to avoid breaking the old moxaload.
>>   Let's rename it to MOXA_GET_CONF_OLD or MOXA_GET_CONF_BAD in the drive=
r.
>> * Create a new MOXA_GET_CONF ioctl (with a new
>>   number, of course), that does it "the right way".
>>   If you don't like renaming ioctl's, we need a new name for this one.
>> * Rewrite moxaload to either do a kernel version check
>>   and use the new ioctl if available or the old if not.
>>   Or skip that and let it call the new ioctl first.
>>   If it succeeds (system running a newer kernel): fine, and
>>   if not (system running an older kernel), use the old ioctl.
>>=20
>> The MOXA Intellio driver and moxaload have been "broken" ever since they
>> were written in 1999, and this way, we don't break anything - you can
>> use old or new kernel, and old or new moxaload in any combination.
>>=20
>> Whaddaya think ?
>
> We won't need anything from that. I'm almost done with firmware support. =
The=20
> only thing you'll need to do is to copy the .cod file(s) into /lib/firmwa=
re=20
> or wherever your firmware loader (probably udev nowadays) finds such file=
s.
>
> Could you post me lspci -vvxxx output of your moxa card?
>
> thanks,
> --js

Ah, I see, you want to get rid of moxaload altogether ...

I'll test your patch series as soon as I get a chance - need to put a
MOXA card into a non-production machine first, so it'll be a few days.

We have a few MOXA Intellio C320 Turbo PCI
cards, here's lspci -vvxxx for one of them:

02:02.0 Serial controller: Moxa Technologies Co Ltd Intellio C320 Turbo PCI=
 (rev 02) (prog-if 80)
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin A routed to IRQ 16
         Region 1: I/O ports at 9400 [size=3D128]
         Region 2: Memory at fb200000 (32-bit, non-prefetchable) [size=3D16=
K]
00: 93 13 00 32 03 00 80 02 02 80 00 07 08 00 00 00
10: 00 00 00 00 01 94 00 00 00 00 20 fb 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

The other cards looks identical, except for unimportant differences
in region mapping and IRQ allocation due to system differences.

=D8yvind.

**************************************************************************
* =D8yvind Aabling     E-mail : Oyvind.Aabling@uni-c.dk    /~\ The ASCII   =
*
* UNI-C Lyngby       Phone  : +45 35 87 88 89            \ / Ribbon      *
* DTU Building 304   Phone  : +45 35 87 89 51 (direct)    X  Campaign    *
* DK-2800 LYNGBY     Fax    : +45 35 87 89 90            / \ Against     *
* Denmark                                                    HTML Email! *
**************************************************************************
---511572392-399198121-1201217676=:3424--
