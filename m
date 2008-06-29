Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYF2StD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYF2StD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 14:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYF2Ssw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 14:48:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:13093 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYF2Ssu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 14:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:message-id:from;
        b=sMlAkMmQoWv9BOj0RDmiblhXPtVNsMAiXihoBMTX5mt5FYNCNjlgD3zchdwtMIr7QF
         8HhIYemItmpGT67CncjuTLtnkPdjF3hRDql954hPM9kkKaijts1tNzknF+QYYcWvyCRK
         tgcZBm8k1+9wkkAfIcJ4P4273rEZE6cGip3c4=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc (fwd)
Date: Sun, 29 Jun 2008 20:51:56 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <20080620175729.GA3151@ime.usp.br> <20080620195815.GA2703@ime.usp.br> <20080625194937.GA13636@ime.usp.br>
In-Reply-To: <20080625194937.GA13636@ime.usp.br>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Mn9ZI83smi2uLqS"
Message-Id: <200806292051.56596.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Mn9ZI83smi2uLqS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

[Added rt2400-devel to CC list]

> > > > Did you receive my earlier message (attached here for reference)? I'm
> > > > willing to experiment with the driver a little bit and I hope that the
> > > > information that I have provided so far is helpful to chase the reason
> > > > why the driver doesn't work on PowerPC.
> > > 
> > > Sorry I have been quite busy with other things.
> > 
> > I'm terribly sorry for that, since I would like the driver to work with
> > the USB stick still in the 2.6.26 release (since that's what some
> > distributions will probably use).
> 
> Just for your information, I just compiled the -rc7 kernel on x86-64 (where
> rt2500usb works if I boot with kernel 2.6.25) and still doesn't work (I'm
> not even mentioning here PowerPC).

In case other people are interested in the register differences as well,
attached is the real difference between the registers. Registers that are
different have the register name and meaning on the right side.

Interesting things to note:
 - SIFS/EIFS timing is different, which is expected since rt2500usb now
    listens to mac80211 for this information.
 - Activity led is disabled, not interesting for this bug, but it really should have
   been set to 1.
 - mac80211 now uses short preamble
 - Basic rates mask is 0, this is very odd....
 - Link tuner value is set to 0, I seriously doubt that is a correct value
 - TX power is different, mac80211 probably has set it to something different

Thats it for now, if anybody has any ideas, please let me know. :)

Ivo

--Boundary-00=_Mn9ZI83smi2uLqS
Content-Type: text/plain;
  charset="iso-8859-1";
  name="diff.rt2500usb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="diff.rt2500usb.txt"

2.6.25.4-1                                                    | 2.6.26-rc5-2
driver: rt2500usb                                               driver: rt2500usb
version: 2.0.14                                               | version: 2.1.4
compiled: Jun 13 2008 01:33:03                                | compiled: Jun  8 2008 17:08:54
dev_flags: 0x0001012f                                         | dev_flags: 0x00000e2f
rt chip: 1201                                                   rt chip: 1201
rf chip: 0005                                                   rf chip: 0005
revision:00000005                                               revision:00000005

csr length: 128                                                 csr length: 128
eeprom length: 53                                               eeprom length: 53
bbp length: 96                                                  bbp length: 96
rf length: 5                                                    rf length: 5

csr                                                             csr
0 :0x0005                                                       0 :0x0005
1 :0x0004                                                       1 :0x0004
2 :0x1300                                                       2 :0x1300
3 :0xe946                                                       3 :0xe946
4 :0x8a8d                                                       4 :0x8a8d
5 :0x1300                                                       5 :0x1300
6 :0x5146                                                       6 :0x5146
7 :0x6510                                                       7 :0x6510
8 :0x0980                                                       8 :0x0980
9 :0xff1d                                                       9 :0xff1d
10 :0x0014                                                      10 :0x0014
11 :0x0005                                                    | 11 :0x000a	MAC_CSR11: SIFS.
12 :0x016c                                                    | 12 :0x013a	MAC_CSR12: EIFS.
13 :0x1111                                                      13 :0x1111
14 :0x1e11                                                      14 :0x1e11
15 :0x01ee                                                      15 :0x01ee
16 :0x0000                                                      16 :0x0000
17 :0x01fe                                                      17 :0x01fe
18 :0x005a                                                      18 :0x005a
19 :0xff00                                                      19 :0xff00
20 :0x0003                                                    | 20 :0x0002	MAC_CSR20: LED control register.
21 :0x1e46                                                      21 :0x1e46
22 :0x0053                                                      22 :0x0053
23 :0x0000                                                      23 :0x0000
24 :0x0000                                                      24 :0x0000
25 :0x0000                                                      25 :0x0000
26 :0x0000                                                      26 :0x0000
27 :0x0000                                                      27 :0x0000
28 :0x0000                                                      28 :0x0000
29 :0x0000                                                      29 :0x0000
30 :0x0000                                                      30 :0x0000
31 :0x0000                                                      31 :0x0000
32 :0x1ec0                                                      32 :0x1ec0
33 :0xb11a                                                    | 33 :0xb162	TXRX_CSR1: TX configuration.
34 :0x007e                                                      34 :0x007e
35 :0xb3af                                                      35 :0xb3af
36 :0xb3aa                                                      36 :0xb3aa
37 :0x8c8d                                                      37 :0x8c8d
38 :0x8b8a                                                      38 :0x8b8a
39 :0x8687                                                      39 :0x8687
40 :0x0085                                                      40 :0x0085
41 :0x0162                                                      41 :0x0162
42 :0x000e                                                    | 42 :0x000a	TXRX_CSR10: Auto responder control.
43 :0x015f                                                    | 43 :0x0000	TXRX_CSR11: Auto responder basic rate.
44 :0x140a                                                      44 :0x140a
45 :0x7038                                                      45 :0x7038
46 :0x0c13                                                      46 :0x0c13
47 :0x0609                                                      47 :0x0609
48 :0x0305                                                      48 :0x0305
49 :0x0203                                                      49 :0x0203
50 :0xfa00                                                      50 :0xfa00
51 :0x0003                                                    | 51 :0x000b	TXRX_CSR19: Synchronization control register.
52 :0x0003                                                      52 :0x0003
53 :0xe78f                                                      53 :0xe78f
54 :0x0000                                                      54 :0x0000
55 :0x0000                                                      55 :0x0000
56 :0x0000                                                      56 :0x0000
57 :0x0000                                                      57 :0x0000
58 :0x0000                                                      58 :0x0000
59 :0x0000                                                      59 :0x0000
60 :0x0000                                                      60 :0x0000
61 :0x0000                                                      61 :0x0000
62 :0x0000                                                      62 :0x0000
63 :0x0000                                                      63 :0x0000
64 :0x0000                                                      64 :0x0000
65 :0x0000                                                      65 :0x0000
66 :0x0000                                                      66 :0x0000
67 :0x0000                                                      67 :0x0000
68 :0x0000                                                      68 :0x0000
69 :0x0000                                                      69 :0x0000
70 :0x0000                                                      70 :0x0000
71 :0x0000                                                      71 :0x0000
72 :0x0000                                                      72 :0x0000
73 :0x0000                                                      73 :0x0000
74 :0x0000                                                      74 :0x0000
75 :0x0000                                                      75 :0x0000
76 :0x0000                                                      76 :0x0000
77 :0x0000                                                      77 :0x0000
78 :0x0000                                                      78 :0x0000
79 :0x0000                                                      79 :0x0000
80 :0x0000                                                      80 :0x0000
81 :0x0000                                                      81 :0x0000
82 :0x0000                                                      82 :0x0000
83 :0x0000                                                      83 :0x0000
84 :0x0000                                                      84 :0x0000
85 :0x0000                                                      85 :0x0000
86 :0x0000                                                      86 :0x0000
87 :0x0000                                                      87 :0x0000
88 :0x0000                                                      88 :0x0000
89 :0x0000                                                      89 :0x0000
90 :0x0000                                                      90 :0x0000
91 :0x0000                                                      91 :0x0000
92 :0x0000                                                      92 :0x0000
93 :0x0000                                                      93 :0x0000
94 :0x0000                                                      94 :0x0000
95 :0x0000                                                      95 :0x0000
96 :0x1221                                                      96 :0x1221
97 :0x0003                                                      97 :0x0003
98 :0x0000                                                      98 :0x0000
99 :0x0000                                                      99 :0x0000
100 :0x000f                                                     100 :0x000f
101 :0x8206                                                     101 :0x8206
102 :0x821e                                                     102 :0x821e
103 :0x9160                                                   | 103 :0x9100	PHY_CSR7: BBP access register 0.
104 :0x0000                                                     104 :0x0000
105 :0x0e07                                                     105 :0x0e07
106 :0x5400                                                     106 :0x5400
107 :0x0000                                                     107 :0x0000
108 :0x0000                                                     108 :0x0000
109 :0x0000                                                     109 :0x0000
110 :0x0000                                                     110 :0x0000
111 :0x0000                                                     111 :0x0000
112 :0x0000                                                   | 112 :0x032c	STA_CSR0: FCS error count.
113 :0x01a9                                                   | 113 :0xfb58	STA_CSR1: PLCP error count.
114 :0x0038                                                   | 114 :0x6311	STA_CSR2: LONG error count.
115 :0x0000                                                   | 115 :0x0a1f	STA_CSR3: CCA false alarm.
116 :0x0000                                                     116 :0x0000
117 :0x0000                                                     117 :0x0000
118 :0x0169                                                   | 118 :0x0000	STA_CSR6
119 :0x0011                                                   | 119 :0x0000	STA_CSR7
120 :0x0000                                                     120 :0x0000
121 :0x0000                                                     121 :0x0000
122 :0x0a01                                                   | 122 :0x02e1	STA_CSR10
123 :0x0000                                                     123 :0x0000
124 :0x0000                                                     124 :0x0000
125 :0x0000                                                     125 :0x0000
126 :0x0000                                                     126 :0x0000
127 :0x0000                                                     127 :0x0000

eeprom                                                          eeprom
0 :0x2570                                                       0 :0x2570
1 :0x0104                                                       1 :0x0104
2 :0x1300                                                       2 :0x1300
3 :0xe946                                                       3 :0xe946
4 :0x8a8d                                                       4 :0x8a8d
5 :0xffff                                                       5 :0xffff
6 :0xffff                                                       6 :0xffff
7 :0xffff                                                       7 :0xffff
8 :0xffff                                                       8 :0xffff
9 :0xffff                                                       9 :0xffff
10 :0xffff                                                      10 :0xffff
11 :0x2829                                                      11 :0x2829
12 :0xfff0                                                      12 :0xfff0
13 :0x00ff                                                      13 :0x00ff
14 :0x112c                                                      14 :0x112c
15 :0x1518                                                      15 :0x1518
16 :0x1618                                                      16 :0x1618
17 :0x3e00                                                      17 :0x3e00
18 :0xffff                                                      18 :0xffff
19 :0xffff                                                      19 :0xffff
20 :0xffff                                                      20 :0xffff
21 :0xffff                                                      21 :0xffff
22 :0xffff                                                      22 :0xffff
23 :0xffff                                                      23 :0xffff
24 :0xffff                                                      24 :0xffff
25 :0xffff                                                      25 :0xffff
26 :0xffff                                                      26 :0xffff
27 :0xffff                                                      27 :0xffff
28 :0xffff                                                      28 :0xffff
29 :0xffff                                                      29 :0xffff
30 :0x1717                                                      30 :0x1717
31 :0x1717                                                      31 :0x1717
32 :0x1717                                                      32 :0x1717
33 :0x1717                                                      33 :0x1717
34 :0x1617                                                      34 :0x1617
35 :0x1616                                                      35 :0x1616
36 :0x1616                                                      36 :0x1616
37 :0xffff                                                      37 :0xffff
38 :0xffff                                                      38 :0xffff
39 :0xffff                                                      39 :0xffff
40 :0xffff                                                      40 :0xffff
41 :0xffff                                                      41 :0xffff
42 :0xffff                                                      42 :0xffff
43 :0xffff                                                      43 :0xffff
44 :0xffff                                                      44 :0xffff
45 :0xffff                                                      45 :0xffff
46 :0xffff                                                      46 :0xffff
47 :0xffff                                                      47 :0xffff
48 :0x0032                                                      48 :0x0032
49 :0x6880                                                      49 :0x6880
50 :0x3850                                                      50 :0x3850
51 :0x6f5f                                                      51 :0x6f5f
52 :0xff37                                                    | 52 :0xfa00

bbp                                                             bbp
0 :0x13                                                         0 :0x13
1 :0x45                                                       | 1 :0x55
2 :0x1e                                                       | 2 :0x06	R2: TX antenna control
3 :0x02                                                         3 :0x02
4 :0x19                                                         4 :0x19
5 :0x09                                                       | 5 :0x0b
6 :0x00                                                       | 6 :0x10
7 :0x0e                                                       | 7 :0x00
8 :0x00                                                         8 :0x00
9 :0x00                                                         9 :0x00
10 :0x00                                                        10 :0x00
11 :0x04                                                        11 :0x04
12 :0x00                                                      | 12 :0x01
13 :0x70                                                      | 13 :0xa8
14 :0x1a                                                        14 :0x1a
15 :0x30                                                        15 :0x30
16 :0xac                                                        16 :0xac
17 :0x60                                                      | 17 :0x00
18 :0x18                                                        18 :0x18
19 :0xff                                                        19 :0xff
20 :0x1e                                                        20 :0x1e
21 :0x18                                                        21 :0x18
22 :0x18                                                        22 :0x18
23 :0x08                                                        23 :0x08
24 :0x68                                                      | 24 :0x80
25 :0x38                                                      | 25 :0x50
26 :0x08                                                        26 :0x08
27 :0x23                                                        27 :0x23
28 :0x18                                                        28 :0x18
29 :0x18                                                        29 :0x18
30 :0x10                                                        30 :0x10
31 :0x2b                                                        31 :0x2b
32 :0xb9                                                        32 :0xb9
33 :0x55                                                        33 :0x55
34 :0x12                                                        34 :0x12
35 :0x50                                                        35 :0x50
36 :0x11                                                        36 :0x11
37 :0x05                                                        37 :0x05
38 :0x00                                                        38 :0x00
39 :0xc4                                                        39 :0xc4
40 :0x02                                                        40 :0x02
41 :0x60                                                        41 :0x60
42 :0x08                                                      | 42 :0x09
43 :0x01                                                      | 43 :0x34
44 :0x78                                                      | 44 :0x0b
45 :0x00                                                      | 45 :0x6e
46 :0x38                                                      | 46 :0x70
47 :0x0a                                                        47 :0x0a
48 :0x04                                                        48 :0x04
49 :0x02                                                        49 :0x02
50 :0x68                                                        50 :0x68
51 :0x56                                                      | 51 :0x18
52 :0x2e                                                      | 52 :0x04
53 :0x10                                                        53 :0x10
54 :0x18                                                        54 :0x18
55 :0x7b                                                      | 55 :0x2d
56 :0x08                                                        56 :0x08
57 :0x10                                                        57 :0x10
58 :0x08                                                        58 :0x08
59 :0x02                                                        59 :0x02
60 :0x3f                                                      | 60 :0x3e
61 :0x6f                                                      | 61 :0x5f
62 :0x00                                                        62 :0x00
63 :0x00                                                        63 :0x00
64 :0x01                                                        64 :0x01
65 :0x03                                                        65 :0x03
66 :0x00                                                        66 :0x00
67 :0x00                                                        67 :0x00
68 :0x00                                                        68 :0x00
69 :0x00                                                        69 :0x00
70 :0x46                                                        70 :0x46
71 :0x00                                                        71 :0x00
72 :0x00                                                        72 :0x00
73 :0x00                                                        73 :0x00
74 :0xd4                                                        74 :0xd4
75 :0xff                                                        75 :0xff
76 :0x19                                                        76 :0x19
77 :0x05                                                        77 :0x05
78 :0x08                                                        78 :0x08
79 :0x00                                                        79 :0x00
80 :0x00                                                        80 :0x00
81 :0x05                                                        81 :0x05
82 :0x14                                                        82 :0x14
83 :0x50                                                        83 :0x50
84 :0xc0                                                        84 :0xc0
85 :0x10                                                        85 :0x10
86 :0x74                                                      | 86 :0xcf
87 :0x04                                                      | 87 :0x00
88 :0x00                                                        88 :0x00
89 :0x00                                                        89 :0x00
90 :0x00                                                        90 :0x00
91 :0x00                                                        91 :0x00
92 :0x00                                                        92 :0x00
93 :0x00                                                        93 :0x00
94 :0x00                                                        94 :0x00
95 :0x00                                                        95 :0x00

rf                                                              rf
0 :0x00000000                                                   0 :0x00000000
1 :0x00022010                                                   1 :0x00022010
2 :0x000008a6                                                   2 :0x000008a6
3 :0x00063711                                                 | 3 :0x00062d11
4 :0x00000e07                                                   4 :0x00000e07
--Boundary-00=_Mn9ZI83smi2uLqS--
