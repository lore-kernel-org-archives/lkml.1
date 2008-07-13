Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYGMA3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYGMA3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 20:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYGMA3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 20:29:33 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:37880 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYGMA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 20:29:32 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jul 2008 20:29:31 EDT
Date: Sat, 12 Jul 2008 21:20:07 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>, rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
	(fwd)
Message-ID: <20080713002006.GA2831@ime.usp.br>
References: <20080620175729.GA3151@ime.usp.br> <200806292051.56596.IvDoorn@gmail.com> <20080708035512.GA550@ime.usp.br> <200807081558.20365.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807081558.20365.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Ivo, John, Linus and all the people at the mailing lists.

It seems that I'm flooded with bad luck. :-( I tried the modifications
in the script attached (progressively uncommenting the commands, as you
asked me), but it seems that I had the bad luck that nothing worked with
kernel 2.6.26-rc5. I also tried with kernel 2.6.26-rc9, but again,
nothing worked [*].

The only thing that gave a signal of life was when I imitated what you
did and set the led register to the value that was present on the
2.6.25.x kernel. Then, a "iwconfig wlan0 ap any" gave me blinks on the
"Act" led each time that I issued the command.

Attached also is the "meat" of the dmesg of my system. You may notice
that after some time, I tried simply "ifdown wlan0" and "ifup wlan0" in
my Debian system. These commands are responsible, as you should guess,
for bringing an interface down and up.

I have not checked closely, but it seems that the modifications to the
registers are lost when you bring the interface down---is that right?
>From the dmesg logs, this seems to be the case.

On Jul 08 2008, Ivo van Doorn wrote:
> Hi,
> 
> Could you try some of the following tests to control the registers:
> I have grouped each test together, please don't do them all in one single shot,
> since that will not help narrowing down the exact register which
> breaks everything.

Again, I didn't do everything in one single shot. I tested your
directions one at a time (first the 1st one, then, the 1st set and the
2nd set, then the 1st, 2nd, and 3rd set etc).

> > > 11 :0x0005                                                    | 11 :0x000a	MAC_CSR11: SIFS.
> > > 12 :0x016c                                                    | 12 :0x013a	MAC_CSR12: EIFS.
> 
> echo 11 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
> echo 5 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
> echo 12 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
> echo 364 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
> 
> ---
> 
> > > 33 :0xb11a                                                    | 33 :0xb162	TXRX_CSR1: TX configuration.
> 
> echo 33 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
> echo 45338 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
> 
> ---
> 
> > > 42 :0x000e                                                    | 42 :0x000a	TXRX_CSR10: Auto responder control.
> > > 43 :0x015f                                                    | 43 :0x0000	TXRX_CSR11: Auto responder basic rate.
> 
> echo 42 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
> echo 14 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
> echo 43 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
> echo 351 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
> 
> ---
> 
> > > 2 :0x1e                                                       | 2 :0x06	R2: TX antenna control
> 
> echo 2 > /<debugfsroot>/<mac80211>/rt2500usb/register/bbp_offset
> echo 30 > /<debugfsroot>/<mac80211>/rt2500usb/register/bbp_value

I attach to this message the commands that I used. As you can see, I
tried some which seemed to me (as a layman) that would make some
difference, but they did nothing. :-( My commands were based on some of
the differences that you narrowed down in the last message.


Thank you very much, Rogério Brito.

[*] Actually, I got it once to work/authenticate with kernel 2.6.26-rc9,
but I couldn't reproduce the steps to that. I tried loading all the
registers this time with the script that I attach here, and I was so sad
that it didn't work a second time (and a third, etc) that I was running
a script that did:

"ifconfig wlan0 up; iwconfig wlan0 key s:xxx; iwconfig wlan0 essid
default" && iwconfig wlan0

Not even once it showed that it was associated with the ap, but once in
a while (not every time) that I run the line above the "act" led blinked
and the messages generated on the dmesg were slightly different from one
time to another (compressed, the log is quite small).
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="rtusb2500-try04.txt"

#!/bin/sh

echo 11 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 5 > /debug/ieee80211/phy0/rt2500usb/register/csr_value
echo 12 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 364 > /debug/ieee80211/phy0/rt2500usb/register/csr_value

echo 33 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 45338 > /debug/ieee80211/phy0/rt2500usb/register/csr_value

echo 42 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 14 > /debug/ieee80211/phy0/rt2500usb/register/csr_value
echo 43 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 351 > /debug/ieee80211/phy0/rt2500usb/register/csr_value

echo 2 > /debug/ieee80211/phy0/rt2500usb/register/bbp_offset
echo 30 > /debug/ieee80211/phy0/rt2500usb/register/bbp_value

# My modifications
echo 20 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 3 > /debug/ieee80211/phy0/rt2500usb/register/csr_value

echo 103 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 37216 > /debug/ieee80211/phy0/rt2500usb/register/csr_value


echo 51 > /debug/ieee80211/phy0/rt2500usb/register/csr_offset
echo 3 > /debug/ieee80211/phy0/rt2500usb/register/csr_value

echo 3 > /debug/ieee80211/phy0/rt2500usb/register/rf_offset
echo 407313 > /debug/ieee80211/phy0/rt2500usb/register/rf_value

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="dmesg-with-2.6.25.txt"

phy0 -> rt2500usb_init_bbp: Debug - Start initialization from EEPROM...
phy0 -> rt2500usb_init_bbp: Debug - BBP: 0x11, value: 0x2c.
phy0 -> rt2500usb_init_bbp: Debug - BBP: 0x15, value: 0x18.
phy0 -> rt2500usb_init_bbp: Debug - BBP: 0x16, value: 0x18.
phy0 -> rt2500usb_init_bbp: Debug - BBP: 0x3e, value: 0x00.
phy0 -> rt2500usb_init_bbp: Debug - ...End initialization from EEPROM.
HW CONFIG: channel=1 freq=2412 phymode=2
phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - CWmin: 4, CWmax: 10, Aifs: 2.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - CWmin: 4, CWmax: 10, Aifs: 2.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - CWmin: 5, CWmax: 10, Aifs: 2.
HW CONFIG: channel=1 freq=2412 phymode=2
HW CONFIG: channel=2 freq=2417 phymode=2
HW CONFIG: channel=3 freq=2422 phymode=2
HW CONFIG: channel=4 freq=2427 phymode=2
HW CONFIG: channel=5 freq=2432 phymode=2
HW CONFIG: channel=6 freq=2437 phymode=2
HW CONFIG: channel=7 freq=2442 phymode=2
HW CONFIG: channel=8 freq=2447 phymode=2
HW CONFIG: channel=9 freq=2452 phymode=2
HW CONFIG: channel=10 freq=2457 phymode=2
HW CONFIG: channel=11 freq=2462 phymode=2
HW CONFIG: channel=1 freq=2412 phymode=2
HW CONFIG: channel=6 freq=2437 phymode=2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:13:46:51:10:65
wlan0: RX authentication from 00:13:46:51:10:65 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:13:46:51:10:65
wlan0: RX AssocResp from 00:13:46:51:10:65 (capab=0x431 status=0 aid=1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:13:46:51:10:65)
phy0: Added STA 00:13:46:51:10:65

--NzB8fVQJ5HfG6fxh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="dmesg-2.6.26-rc9.txt.gz"
Content-Transfer-Encoding: base64

H4sICJdFeUgCA2RtZXNnLTIuNi4yNi1yYzkudHh0AO2dXWvjRhSG7/MrDvRiW7DDSLHTInDB
Dds20HhDtm32zkykkTVgS97RKMn++x55vevstuo2ppRePAaDPs6H5jkz74yMkLv2TqbjJJPa
PUjlV5W0W+cK+e31D1K4e5876Vpfr8RVuV9WeSG21m9RBNe2kp50H/zzpi79qgs2+qaWrxLJ
q6Z1tZSh2chuT2MdzBea7kmOsunqYiS++N3VRRNmqTFJv3sdmqLL4+wsN2bQuY1Br7DN5KoM
M3X74JSO5LUL3q4X3ebOhdmTCHuTTL4z6WmSrOT2l/lC5oXdRhdEPwfTK1t3pc1jF1zIZL64
lJNt9c7I+HsJMZ0ao5bLe7v2hY1u6dxWG5zJy5fXN6+uJLi8uXfhnYxlcXmRiXksy9I8DfBo
zLJ1cZlXfpvJZV02anuhO3pQGxhdHrUcYzXNJEl7KqHUOMZMdcvd7zb7z/R0FzXTJq/f+2gp
XF+WGJq12PWqCT5WG3mx9cWLkxu38q22Ve3W+n1PMju0aLwLFmzhmx5F3oT+7MGp7y6+1m1F
46QIXlt58N5fys+3cvFq8ePlT5l2A/d2lk6S9KhT3w6eSoe90mGvs2Gvs2GvybDXZNhrOuw1
HfY6PwrU/uIPXWtj82U/Mpfx8dC59iNVq/jrG3nbuc6J6Y/fbnydyWTUb1m1T8xI5r7UgZWe
Hhk3+WLch7WtTR/DRx2pYrtYLbWz6mDdn+mPuDr6vO/OD9qFZX6tnT5LzrLJeTZNssRk59P/
2LrXuEF7iX6jEJouUqhBmDdvPue5myn+DPPrXRKJwdatyrBazlKVfBu7dma++avkxceDbdvk
/pjalsFuXK/eToWtGLi0kdx1UeomqhJ+2vr+8pwS9atahbMgyf84yTP6yPNN0QkEHUFH0EmC
oKMT6ARJSEISZiFmIW4rKBSFolAUikJRKApFoSgUhaJQ/EhEEpLwgwRT079gDe5/0nGPGHAf
R8gXRhvh/17v6OooC7jBDW5wgxvc4GYRziqZRTjKAm5wgxvc4AY3q0KWbYRnTYsu8kwEz0SQ
hMcVnvu4AqqCqjAWSYJ0IV1IF0lQFVSFu1pwgxvc4AY3uFmAs2wlCQtwRBzc4AY3uMENbnCD
G9y8rYV3F1AoCoWAgRvc4AY3uMENbnCDG9zg5n6U+1EKRaEoFDMNuMENbnCDG9zgBje4wQ1u
cIMb3OAGNy+cIzzheV0eqg5ucIMb3OBmiUh4whOe8Kz+mbDBDW5wgxvc4AY3uMENbnCDG9zg
Bje4wQ1ucIMb3OAGN7jBzfMAhCc8OoDsghvc4ObvdPg7HZLwTzfoK7i5aSM894S8vI237D27
UH8AyOQiKhzKAAA=

--NzB8fVQJ5HfG6fxh--
