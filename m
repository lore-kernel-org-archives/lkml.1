Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYFHVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYFHVfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYFHVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:35:22 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:42086 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755877AbYFHVfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:35:20 -0400
Date: Sun, 8 Jun 2008 18:35:13 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Rog=E9rio?= Theodoro de Brito 
	<rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080608213513.GA30499@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <20080608001143.GB10775@ime.usp.br> <20080608010207.GA11086@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806081242.54896.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: b2dbf217aace24bdceac7c14ed997afd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Ivo.

First of all, thank you so much for helping with this issue. It is
greatly appreciated.

On Jun 08 2008, Ivo van Doorn wrote:
> Hi,
> 
> > Unfortunately, this patch won't even apply with 2.6.26-rc5 as the code
> > seems to have changed a lot between that date and today. For instance,
> > there doesn't seem to exist a function called "rt2500usb_config_mac_addr"
> > in the rt2x00 directory (just did a grep on my unconnected iBook).
> 
> That patch was a bugfix for 2.6.25. The bug it fixed isn't present in
> the 2.6.26 cycle.

Nice to know that. I saw that the code has changed quite a good amount...

Anyway, I don't know if you saw the various outputs that I put at my
homepage (lots of dmesgs with the 2.6.26-rc4 kernel):
http://www.ime.usp.br/~rbrito/debug/

(Not included here because the list has limits on the size of e-mails, AFAIK).

> > > Just as a refresher:
> > > 
> > > * I can set everything on the iBook with the wireless key plugged;
> > > * The wireless key *sees* the AP, even with encryption (that is, it grabs
> > >   the MAC address of the AP, it (sometimes) shows me the signal strength,
> > >   and if I issue "iwconfig wlan0 ap any", I see both the led of the
> > >   wireless key blink and an increase of amount of data transmitted and
> > >   received with "ifconfig wlan0");

Just a comment here: it seems that with the -rc5 kernel I don't get
always the wireless key seeing the AP... Sometimes it shows "Not
Associated". I will try to reproduce that with an -rc4 kernel again.

> > > * With everything set this way, if I do "dhclient wlan0", it doesn't get a
> > >   lease from the AP---actually, despite the fact that it is possible to see
> > >   the other point, dhclient goes, after some attempts of getting a lease,
> > >   to background, but no address is ever gotten;
> > > * Just to rule out possible problems with something sent to the address
> > >   255.255.255.255 (which is reported as being done by dhclient), I tried to
> > >   configure the address by hand via ifconfig, but, for instance, I couldn't
> > >   ping my AP (which I can from other computers with a rt61pci driver and a
> > >   PCMCIA connection);
> > > * As I mentioned above, I have no problems with the rt61pci driver, but the
> > >   USB one doesn't seem to work (unfortunately, the iBook does not have a
> > >   PCMCIA slot). With a notebook with an on-board Intel wireless card, I
> > >   *also* don't have any problems.
> > > 
> > > Well, thanks, for the help so far. I hope that we can solve this issue
> > > quite soon, as I need this iBook for work.
> > > 
> > > I am willing to help as much as I can and test anything (even something
> > > that might be "experimental"). I think that this is as good a tester that
> > > you can get, right? :-)
> > 
> > Again, I am willing to test any "intrusive" change as I still don't have
> > valuable data on that machine. BTW, I have firmware from Debian's
> > ralink-firmware package (which should be what ralink has released)
> > installed on this machine.
> > 
> > I don't know if the firmware is needed in my case or not, though (my USB
> > adaptor is a D-Link DWL-G122 H/W Ver. B1, F/W Ver.: 2.03---took that info
> > from the back of the stick).
> 
> Which driver is actually being used? rt2500usb or rt73usb?

The driver that actually gets loaded is rt2500usb. I tried rmmod'ing
rt2500usb and loading rt73usb, but a quick iwconfig doesn't even show
the interfaces.

> Also what was the last kernel version on which the driver worked for
> you?

Unfortunately, I don't have any kernel for which this has worked for
me. I just did an experiment: I plugged the adaptor on a ia32 notebook
where a rt61pci works fine (it is running Ubuntu's Hardy---well,
actually, there are some problems, but I can get to that latter), but
the USB key was non working with the symptoms that I described above.

> If there was a last known working kernel, could you download the debugfs script:
> 	http://rt2x00.serialmonkey.com/phpBB/download/file.php?id=1969
> enable debugfs and MAC80211_DEBUGFS and RT2X00_LIB_DEBUGFS in your kernel,
> and run the script to dump all registers from the hardware to a file?

I just grabbed the script. Here is the output with the options enabled
and the results are attached here.

> Please do this for both the working kernel as the non-working kernel
> so I can see if there is a register initialization problem which could
> have been triggered by an endian-problem.

That was my first suspicion: and endianess problem. But now I am not so
sure.


Thanks again, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="output-regdump.txt"

2.6.26-rc5-2
driver: rt2500usb
version: 2.1.4
compiled: Jun  8 2008 17:08:54
dev_flags: 0x00000e2f
rt chip: 1201
rf chip: 0005
revision:00000005

csr length: 128
eeprom length: 53
bbp length: 96
rf length: 5

csr
0 :0x00050000
1 :0x00040000
2 :0x13000000
3 :0xe9460000
4 :0x8a8d0000
5 :0x13000000
6 :0x51460000
7 :0x65100000
8 :0x09800000
9 :0xff1d0000
10 :0x00140000
11 :0x000a0000
12 :0x013a0000
13 :0x11110000
14 :0x1e110000
15 :0x01ee0000
16 :0x00000000
17 :0x01fe0000
18 :0x005a0000
19 :0xff000000
20 :0x00020000
21 :0x1e460000
22 :0x00530000
23 :0x00000000
24 :0x00000000
25 :0x00000000
26 :0x00000000
27 :0x00000000
28 :0x00000000
29 :0x00000000
30 :0x00000000
31 :0x00000000
32 :0x1ec00000
33 :0xb1620000
34 :0x007e0000
35 :0xb3af0000
36 :0xb3aa0000
37 :0x8c8d0000
38 :0x8b8a0000
39 :0x86870000
40 :0x00850000
41 :0x01620000
42 :0x000a0000
43 :0x00000000
44 :0x140a0000
45 :0x70380000
46 :0x0c130000
47 :0x06090000
48 :0x03050000
49 :0x02030000
50 :0xfa000000
51 :0x000b0000
52 :0x00030000
53 :0xe78f0000
54 :0x00000000
55 :0x00000000
56 :0x00000000
57 :0x00000000
58 :0x00000000
59 :0x00000000
60 :0x00000000
61 :0x00000000
62 :0x00000000
63 :0x00000000
64 :0x00000000
65 :0x00000000
66 :0x00000000
67 :0x00000000
68 :0x00000000
69 :0x00000000
70 :0x00000000
71 :0x00000000
72 :0x00000000
73 :0x00000000
74 :0x00000000
75 :0x00000000
76 :0x00000000
77 :0x00000000
78 :0x00000000
79 :0x00000000
80 :0x00000000
81 :0x00000000
82 :0x00000000
83 :0x00000000
84 :0x00000000
85 :0x00000000
86 :0x00000000
87 :0x00000000
88 :0x00000000
89 :0x00000000
90 :0x00000000
91 :0x00000000
92 :0x00000000
93 :0x00000000
94 :0x00000000
95 :0x00000000
96 :0x12210000
97 :0x00030000
98 :0x00000000
99 :0x00000000
100 :0x000f0000
101 :0x82060000
102 :0x821e0000
103 :0x91000000
104 :0x00000000
105 :0x0e070000
106 :0x54000000
107 :0x00000000
108 :0x00000000
109 :0x00000000
110 :0x00000000
111 :0x00000000
112 :0x032c0000
113 :0xfb580000
114 :0x63110000
115 :0x0a1f0000
116 :0x00000000
117 :0x00000000
118 :0x00000000
119 :0x00000000
120 :0x00000000
121 :0x00000000
122 :0x02e10000
123 :0x00000000
124 :0x00000000
125 :0x00000000
126 :0x00000000
127 :0x00000422

eeprom
0 :0x2570
1 :0x0104
2 :0x1300
3 :0xe946
4 :0x8a8d
5 :0xffff
6 :0xffff
7 :0xffff
8 :0xffff
9 :0xffff
10 :0xffff
11 :0x2829
12 :0xfff0
13 :0x00ff
14 :0x112c
15 :0x1518
16 :0x1618
17 :0x3e00
18 :0xffff
19 :0xffff
20 :0xffff
21 :0xffff
22 :0xffff
23 :0xffff
24 :0xffff
25 :0xffff
26 :0xffff
27 :0xffff
28 :0xffff
29 :0xffff
30 :0x1717
31 :0x1717
32 :0x1717
33 :0x1717
34 :0x1617
35 :0x1616
36 :0x1616
37 :0xffff
38 :0xffff
39 :0xffff
40 :0xffff
41 :0xffff
42 :0xffff
43 :0xffff
44 :0xffff
45 :0xffff
46 :0xffff
47 :0xffff
48 :0x0032
49 :0x6880
50 :0x3850
51 :0x6f5f
52 :0xfa00

bbp
0 :0x13
1 :0x55
2 :0x06
3 :0x02
4 :0x19
5 :0x0b
6 :0x10
7 :0x00
8 :0x00
9 :0x00
10 :0x00
11 :0x04
12 :0x01
13 :0xa8
14 :0x1a
15 :0x30
16 :0xac
17 :0x00
18 :0x18
19 :0xff
20 :0x1e
21 :0x18
22 :0x18
23 :0x08
24 :0x80
25 :0x50
26 :0x08
27 :0x23
28 :0x18
29 :0x18
30 :0x10
31 :0x2b
32 :0xb9
33 :0x55
34 :0x12
35 :0x50
36 :0x11
37 :0x05
38 :0x00
39 :0xc4
40 :0x02
41 :0x60
42 :0x09
43 :0x34
44 :0x0b
45 :0x6e
46 :0x70
47 :0x0a
48 :0x04
49 :0x02
50 :0x68
51 :0x18
52 :0x04
53 :0x10
54 :0x18
55 :0x2d
56 :0x08
57 :0x10
58 :0x08
59 :0x02
60 :0x3e
61 :0x5f
62 :0x00
63 :0x00
64 :0x01
65 :0x03
66 :0x00
67 :0x00
68 :0x00
69 :0x00
70 :0x46
71 :0x00
72 :0x00
73 :0x00
74 :0xd4
75 :0xff
76 :0x19
77 :0x05
78 :0x08
79 :0x00
80 :0x00
81 :0x05
82 :0x14
83 :0x50
84 :0xc0
85 :0x10
86 :0xcf
87 :0x00
88 :0x00
89 :0x00
90 :0x00
91 :0x00
92 :0x00
93 :0x00
94 :0x00
95 :0x00

rf
0 :0x00000000
1 :0x00022010
2 :0x000008a6
3 :0x00062d11
4 :0x00000e07

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="ifconfig-wlan0.txt"

wlan0     Link encap:Ethernet  HWaddr 00:13:46:e9:8d:8a  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="iwlist-wlan0-scan.txt"

wlan0     Scan completed :
          Cell 01 - Address: 00:13:46:51:10:65
                    ESSID:"default"
                    Mode:Master
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=51/100  Signal level=-53 dBm  
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=0000005b34700179


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="iwconfig-wlan0.txt"

wlan0     IEEE 802.11  ESSID:"default"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated   
          Tx-Power=22 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XX
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


--0OAP2g/MAC+5xKAE
Content-Type: application/x-sh
Content-Disposition: attachment; filename="levanta.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0Aifconfig wlan0 up=0Aiwconfig wlan0 key s:XXXXXXXXXXXXX=0Aiwc=
onfig wlan0 essid default=0Aiwconfig wlan0 ap any=0A
--0OAP2g/MAC+5xKAE--
