Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYFTSFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYFTSFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFTSFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:05:32 -0400
Received: from smtpout1.uol.com.br ([200.221.4.192]:50586 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972AbYFTSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:05:30 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 14:05:30 EDT
Date: Fri, 20 Jun 2008 14:57:29 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
	(fwd)
Message-ID: <20080620175729.GA3151@ime.usp.br>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 7d393de52d5c5a30b294355a4a17356f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Dear Ivo and John (among others),

Did you receive my earlier message (attached here for reference)? I'm
willing to experiment with the driver a little bit and I hope that the
information that I have provided so far is helpful to chase the reason
why the driver doesn't work on PowerPC.

BTW, the latest kernel that I tried on a x86-64 machine was a 2.6.26-rc6
and it showed the same results as with kernel 2.6.26-rc5: I couldn't
associate with the AP.

OTOH, reverting back to 2.6.25 on this (x86-64) machine, I can use the
D-Link USB stick without any problems.

If you need more information, I will be glad to assist you to have
everything fixed.

I am willing to use any git tree, if that helps.


Thanks in advance, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--mP3DRpeJDSE+ciuQ
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Date: Fri, 13 Jun 2008 01:52:09 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080613045209.GA2421@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806112021.50264.IvDoorn@gmail.com> <20080612042320.GB19980@ime.usp.br> <200806121940.28882.IvDoorn@gmail.com> <20080613040634.GA3281@ime.usp.br>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080613040634.GA3281@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi again, Ivo and John.

I have finally made the rt2x00 work on the x86-64 with the kernel
2.6.25.

Just as a reminder:

* with kernel 2.6.26-rc4, I could associate with the AP, but could not
  get a DHCP lease;
* with kernel 2.6.26-rc5, I could not even associate with the AP.

So, it seems that we have some regressions here. :-(

> Well, I'm attaching the diff between the regdump from the earlier try
> on the iBook and the regdump from this x86-64. I think that some
> conclusions may be drawn from it, since it seems to be your domain of
> expertise.

I'm attaching here 3 files: the old output from regdump (taken from the
ibook), the new, working (with kernel 2.6.25.4) regdump and their diff.
Notice that there are some inverted values there, but they are shorts
(i.e., 16-bit integers) that are inverted, instead of the inverted
values being bytes.

I think that this may mean that your work may be easier on debugging the
driver (I hope so!).


Thanks for any help, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="old.output-regdump.txt"

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

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="new.output-regdump.txt"

2.6.25.4-1
driver: rt2500usb
version: 2.0.14
compiled: Jun 13 2008 01:33:03
dev_flags: 0x0001012f
rt chip: 1201
rf chip: 0005
revision:00000005

csr length: 128
eeprom length: 53
bbp length: 96
rf length: 5

csr
0 :0x00000005
1 :0x00000004
2 :0x00001300
3 :0x0000e946
4 :0x00008a8d
5 :0x00001300
6 :0x00005146
7 :0x00006510
8 :0x00000980
9 :0x0000ff1d
10 :0x00000014
11 :0x00000005
12 :0x0000016c
13 :0x00001111
14 :0x00001e11
15 :0x000001ee
16 :0x00000000
17 :0x000001fe
18 :0x0000005a
19 :0x0000ff00
20 :0x00000003
21 :0x00001e46
22 :0x00000053
23 :0x00000000
24 :0x00000000
25 :0x00000000
26 :0xffff0000
27 :0x00000000
28 :0x00000000
29 :0x00000000
30 :0x00000000
31 :0x00000000
32 :0x00001ec0
33 :0x0000b11a
34 :0x0000007e
35 :0x0000b3af
36 :0x0000b3aa
37 :0x00008c8d
38 :0x00008b8a
39 :0x00008687
40 :0x00000085
41 :0x00000162
42 :0x0000000e
43 :0x0000015f
44 :0x0000140a
45 :0x00007038
46 :0x00000c13
47 :0x00000609
48 :0x00000305
49 :0x00000203
50 :0x0000fa00
51 :0x00000003
52 :0x00000003
53 :0x0000e78f
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
96 :0x00001221
97 :0x00000003
98 :0x00000000
99 :0x00000000
100 :0x0000000f
101 :0x00008206
102 :0x0000821e
103 :0x00009160
104 :0x00000000
105 :0x00000e07
106 :0x00005400
107 :0x00000000
108 :0x00000000
109 :0x00000000
110 :0x00000000
111 :0x00000000
112 :0x00000000
113 :0x000001a9
114 :0x00000038
115 :0x00000000
116 :0x00000000
117 :0x00000000
118 :0x00000169
119 :0x00000011
120 :0x00000000
121 :0x00000000
122 :0x00000a01
123 :0x00000000
124 :0x00000000
125 :0x00000000
126 :0x00000000
127 :0x00000000

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
52 :0xff37

bbp
0 :0x13
1 :0x45
2 :0x1e
3 :0x02
4 :0x19
5 :0x09
6 :0x00
7 :0x0e
8 :0x00
9 :0x00
10 :0x00
11 :0x04
12 :0x00
13 :0x70
14 :0x1a
15 :0x30
16 :0xac
17 :0x60
18 :0x18
19 :0xff
20 :0x1e
21 :0x18
22 :0x18
23 :0x08
24 :0x68
25 :0x38
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
42 :0x08
43 :0x01
44 :0x78
45 :0x00
46 :0x38
47 :0x0a
48 :0x04
49 :0x02
50 :0x68
51 :0x56
52 :0x2e
53 :0x10
54 :0x18
55 :0x7b
56 :0x08
57 :0x10
58 :0x08
59 :0x02
60 :0x3f
61 :0x6f
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
86 :0x74
87 :0x04
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
3 :0x00063711
4 :0x00000e07

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="differences.txt"

--- old.output-regdump.txt	2008-06-13 01:41:12.000000000 -0300
+++ new.output-regdump.txt	2008-06-13 01:42:12.000000000 -0300
@@ -1,8 +1,8 @@
-2.6.26-rc5-2
+2.6.25.4-1
 driver: rt2500usb
-version: 2.1.4
-compiled: Jun  8 2008 17:08:54
-dev_flags: 0x00000e2f
+version: 2.0.14
+compiled: Jun 13 2008 01:33:03
+dev_flags: 0x0001012f
 rt chip: 1201
 rf chip: 0005
 revision:00000005
@@ -13,60 +13,60 @@
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
+11 :0x00000005
+12 :0x0000016c
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
+20 :0x00000003
+21 :0x00001e46
+22 :0x00000053
 23 :0x00000000
 24 :0x00000000
 25 :0x00000000
-26 :0x00000000
+26 :0xffff0000
 27 :0x00000000
 28 :0x00000000
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
-43 :0x00000000
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
+32 :0x00001ec0
+33 :0x0000b11a
+34 :0x0000007e
+35 :0x0000b3af
+36 :0x0000b3aa
+37 :0x00008c8d
+38 :0x00008b8a
+39 :0x00008687
+40 :0x00000085
+41 :0x00000162
+42 :0x0000000e
+43 :0x0000015f
+44 :0x0000140a
+45 :0x00007038
+46 :0x00000c13
+47 :0x00000609
+48 :0x00000305
+49 :0x00000203
+50 :0x0000fa00
+51 :0x00000003
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
+103 :0x00009160
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
+112 :0x00000000
+113 :0x000001a9
+114 :0x00000038
+115 :0x00000000
 116 :0x00000000
 117 :0x00000000
-118 :0x00000000
-119 :0x00000000
+118 :0x00000169
+119 :0x00000011
 120 :0x00000000
 121 :0x00000000
-122 :0x02e10000
+122 :0x00000a01
 123 :0x00000000
 124 :0x00000000
 125 :0x00000000
 126 :0x00000000
-127 :0x00000422
+127 :0x00000000
 
 eeprom
 0 :0x2570
@@ -195,35 +195,35 @@
 49 :0x6880
 50 :0x3850
 51 :0x6f5f
-52 :0xfa00
+52 :0xff37
 
 bbp
 0 :0x13
-1 :0x55
-2 :0x06
+1 :0x45
+2 :0x1e
 3 :0x02
 4 :0x19
-5 :0x0b
-6 :0x10
-7 :0x00
+5 :0x09
+6 :0x00
+7 :0x0e
 8 :0x00
 9 :0x00
 10 :0x00
 11 :0x04
-12 :0x01
-13 :0xa8
+12 :0x00
+13 :0x70
 14 :0x1a
 15 :0x30
 16 :0xac
-17 :0x00
+17 :0x60
 18 :0x18
 19 :0xff
 20 :0x1e
 21 :0x18
 22 :0x18
 23 :0x08
-24 :0x80
-25 :0x50
+24 :0x68
+25 :0x38
 26 :0x08
 27 :0x23
 28 :0x18
@@ -240,26 +240,26 @@
 39 :0xc4
 40 :0x02
 41 :0x60
-42 :0x09
-43 :0x34
-44 :0x0b
-45 :0x6e
-46 :0x70
+42 :0x08
+43 :0x01
+44 :0x78
+45 :0x00
+46 :0x38
 47 :0x0a
 48 :0x04
 49 :0x02
 50 :0x68
-51 :0x18
-52 :0x04
+51 :0x56
+52 :0x2e
 53 :0x10
 54 :0x18
-55 :0x2d
+55 :0x7b
 56 :0x08
 57 :0x10
 58 :0x08
 59 :0x02
-60 :0x3e
-61 :0x5f
+60 :0x3f
+61 :0x6f
 62 :0x00
 63 :0x00
 64 :0x01
@@ -284,8 +284,8 @@
 83 :0x50
 84 :0xc0
 85 :0x10
-86 :0xcf
-87 :0x00
+86 :0x74
+87 :0x04
 88 :0x00
 89 :0x00
 90 :0x00
@@ -299,5 +299,5 @@
 0 :0x00000000
 1 :0x00022010
 2 :0x000008a6
-3 :0x00062d11
+3 :0x00063711
 4 :0x00000e07

--Nq2Wo0NMKNjxTN9z--

--mP3DRpeJDSE+ciuQ--
