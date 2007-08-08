Return-Path: <linux-kernel-owner+w=401wt.eu-S935102AbXHHPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbXHHPYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXHHPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:24:46 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:42991 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755337AbXHHPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:24:45 -0400
Date: Wed, 8 Aug 2007 17:17:16 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: bad temperature values from w83781d in 2.6.22
Message-ID: <20070808151716.GA6053@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	"Mark M. Hoffman" <mhoffman@lightlink.com>,
	LKML <linux-kernel@vger.kernel.org>,
	lm-sensors <lm-sensors@lm-sensors.org>
References: <20070805183219.0d54802b.akpm@linux-foundation.org> <20070808010316.GB3584@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070808010316.GB3584@jupiter.solarsys.private>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

just to eliminate as many impacts as possible, I did:
- reinstall the unmodified sensors.conf from Tyan's support page
- power off before rebooting

A call to "sensors -s" is done without errors in all cases.
The module parameters I use currently with both kernels:

options w83781d force_w83782d=0,0x2d force_subclients=0,0x2d,0x48,0x49
options w83627hf force_addr=0x0c00

When I first realized the problem, I didn't use w83627hf yet.  Results
are the same when w83781d is used as driver for w83627hf.
Parameters in that case just from Tyan:

options w83781d force_w83782d=0,0x2d force_subclients=0,0x2d,0x48,0x49 force_w83627hf=0,0x2c force_subclients=0,0x2c,0x4a,0x4b init=0

"My" i2cdump doesn't accept an -y option, maybe a Debianism.  Results
see below.

TIA
-jo

### 2.6.21 ###############################
Script started on Wed Aug  8 16:53:10 2007
bear:~/hwmon# i2cdump 0 0x2d b 0 0x4e
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x2d, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
20: 6c 6b 70 b4 4d 9a ce 3b ff ff f3 80 67 80 67 d8    lkp?M??;..??g?g?
30: c4 c3 b0 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
40: 01 ec 2f 00 00 00 00 54 2d 02 10 44 01 95 00 a3    ??/....T-??D??.?
50: ff ff 00 ff ff ff 00 80 30 00 ff ff 11 0e ff ff    .......?0...??..
60: 6b 6a 70 b3 4d 9b ce 3b ff ff f3 80 67 80 67 d8    kjp?M??;..??g?g?
70: c4 c3 b0 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: 6b 6a 70 b4 4c 9a ce 3b ff ff f5 80 67 80 67 d8    kjp?L??;..??g?g?
b0: c4 c3 b0 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
c0: 01 00 00 00 00 00 00 54 2d 02 10 44 01 95 00 a3    ?......T-??D??.?
d0: ff ff 00 ff ff ff 00 80 30 00 ff ff 11 0e ff ff    .......?0...??..
e0: 6b 6a 6f b1 4d 9a ce 3b ff ff f5 80 67 80 67 d8    kjo?M??;..??g?g?
f0: c4 c3 b0 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
bear:~/hwmon# i2cdump 0 0x48
No size specified (using byte-data access)
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x48, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
10: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
20: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
30: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
40: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
50: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
60: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
70: 3b 00 4b 50 3a 00 4b 50 3a 00 4b 50 3b 00 4b 50    ;.KP:.KP:.KP;.KP
80: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
90: 3b 00 4b 50 3a 00 4b 50 3a 00 4b 50 3b 00 4b 50    ;.KP:.KP:.KP;.KP
a0: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
b0: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
c0: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
d0: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
e0: 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50 3b 00 4b 50    ;.KP;.KP;.KP;.KP
f0: 3a 00 4b 50 3a 00 4b 50 3b 00 4b 50 3b 00 4b 50    :.KP:.KP;.KP;.KP
bear:~/hwmon# i2cdump 0  0x49
No size specified (using byte-data access)
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x49, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
10: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
20: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
30: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
40: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
50: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
60: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
70: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
80: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
90: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
a0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
b0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
c0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
d0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
e0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
f0: 38 00 4b 50 38 00 4b 50 38 00 4b 50 38 00 4b 50    8.KP8.KP8.KP8.KP
bear:~/hwmon# sensors
w83782d-i2c-0-2d
Adapter: SMBus AMD768 adapter at 80e0
AGP V:     +1.74 V  (min =  +3.14 V, max =  +3.46 V)       ALARM  
 +5 V:     +4.81 V  (min =  +4.73 V, max =  +5.24 V)              
DDR V:     +1.23 V  (min =  +2.85 V, max =  +3.47 V)       ALARM  
3 VSB:     +3.30 V  (min =  +2.85 V, max =  +3.15 V)       ALARM  
Bat V:     +0.00 V  (min =  +2.64 V, max =  +3.95 V)       ALARM  
chs1 Fan:    0 RPM  (min = 2700 RPM, div = 2)              ALARM  
chs2 Fan:    0 RPM  (min = 3970 RPM, div = 2)              ALARM  
chs3 Fan:    0 RPM  (min = 10546 RPM, div = 2)              ALARM  
VRM2 Temp:   +56 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
CPU1 Temp: +57.5 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
CPU2 Temp: +56.0 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
alarms:   
beep_enable:
          Sound alarm enabled

w83627hf-isa-0c00
Adapter: ISA adapter
VCore1:    +1.73 V  (min =  +1.66 V, max =  +1.84 V)              
VCore2:    +1.73 V  (min =  +1.66 V, max =  +1.84 V)              
+3.3 V:    +3.33 V  (min =  +3.14 V, max =  +3.47 V)              
 +12 V:   +11.83 V  (min = +13.21 V, max = +10.83 V)       ALARM  
 -12 V:   -12.11 V  (min = -13.18 V, max = -10.80 V)              
CPU1 Fan: 4041 RPM  (min = 4687 RPM, div = 2)              ALARM  
CPU2 Fan: 4192 RPM  (min = 6750 RPM, div = 2)              ALARM  
VRM1 Temp:   +44 C  (high =  -124 C, hyst =   +16 C)   sensor = transistor   ALARM   
AGP Temp:  +50.0 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
DDR Temp:  +46.0 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
alarms:   Chassis intrusion detection                      ALARM
beep_enable:
          Sound alarm disabled

bear:~/hwmon# exit
exit

Script done on Wed Aug  8 16:55:02 2007

### 2.6.22 ###############################
Script started on Wed Aug  8 16:41:41 2007
bear:~/hwmon# i2cdump 0 0x2d b 0 0x4e
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x2d, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
20: 6c 6b 70 b3 4c 9a ce 3b ff ff ff 80 67 80 67 d9    lkp?L??;...?g?g?
30: c4 c3 b1 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
40: 01 ec 2f 00 00 00 00 54 2d 02 10 44 01 95 00 a3    ??/....T-??D??.?
50: ff ff 00 ff ff ff 00 80 30 60 ff ff 11 02 ff ff    .......?0`..??..
60: 6c 6b 6f b3 4c 9a ce 3b ff ff ff 80 67 80 67 d9    lko?L??;...?g?g?
70: c4 c3 b1 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: 6c 6b 6f b4 4c 9b ce 3b ff ff ff 80 67 80 67 d9    lko?L??;...?g?g?
b0: c4 c3 b1 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
c0: 01 08 00 00 00 00 00 54 2d 02 10 44 01 95 00 a3    ??.....T-??D??.?
d0: ff ff 00 ff ff ff 00 80 30 60 ff ff 11 02 ff ff    .......?0`..??..
e0: 6b 6a 6f b4 4c 9a ce 3b ff ff ff 80 67 80 67 d9    kjo?L??;...?g?g?
f0: c4 c3 b1 d9 b2 41 06 c5 b2 50 4b fa aa 40 00 00    ?????A???PK??@..
bear:~/hwmon# i2cdump 0 0x48
No size specified (using byte-data access)
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x48, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
10: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
20: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
30: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
40: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
50: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
60: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
70: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
80: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
90: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
a0: 50 00 4b 50 4f 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPO.KPP.KPP.KP
b0: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
c0: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
d0: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
e0: 50 00 4b 50 50 00 4b 50 4f 00 4b 50 4f 00 4b 50    P.KPP.KPO.KPO.KP
f0: 50 00 4b 50 50 00 4b 50 50 00 4b 50 50 00 4b 50    P.KPP.KPP.KPP.KP
bear:~/hwmon# i2cdump 0 0x49
No size specified (using byte-data access)
  WARNING! This program can confuse your I2C bus, cause data loss and worse!
  I will probe file /dev/i2c-0, address 0x49, mode byte
  You have five seconds to reconsider and press CTRL-C!

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
10: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
20: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
30: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
40: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
50: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
60: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
70: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
80: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
90: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
a0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
b0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
c0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
d0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
e0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
f0: 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50 4f 00 4b 50    O.KPO.KPO.KPO.KP
bear:~/hwmon# sensors
w83782d-i2c-0-2d
Adapter: SMBus AMD768 adapter at 80e0
AGP V:     +1.73 V  (min =  +3.14 V, max =  +3.47 V)       ALARM  
 +5 V:     +4.81 V  (min =  +4.76 V, max =  +5.24 V)              
DDR V:     +1.22 V  (min =  +2.85 V, max =  +3.47 V)       ALARM  
3 VSB:     +3.30 V  (min =  +2.85 V, max =  +3.15 V)       ALARM  
Bat V:     +0.00 V  (min =  +2.64 V, max =  +3.95 V)       ALARM  
chs1 Fan:    0 RPM  (min = 2700 RPM, div = 2)              ALARM  
chs2 Fan:    0 RPM  (min = 3970 RPM, div = 2)              ALARM  
chs3 Fan:    0 RPM  (min = 10546 RPM, div = 2)              ALARM  
VRM2 Temp:   +56 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
CPU1 Temp: +79.5 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor   ALARM   
CPU2 Temp: +79.5 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor   ALARM   
alarms:   
beep_enable:
          Sound alarm enabled

w83627hf-isa-0c00
Adapter: ISA adapter
VCore1:    +1.71 V  (min =  +1.66 V, max =  +1.84 V)              
VCore2:    +1.71 V  (min =  +1.66 V, max =  +1.84 V)              
+3.3 V:    +3.33 V  (min =  +3.14 V, max =  +3.47 V)              
 +12 V:   +11.83 V  (min = +13.21 V, max = +10.83 V)       ALARM  
 -12 V:   -12.20 V  (min = -13.18 V, max = -10.80 V)              
CPU1 Fan: 4041 RPM  (min = 4687 RPM, div = 2)              ALARM  
CPU2 Fan: 4166 RPM  (min = 6750 RPM, div = 2)              ALARM  
VRM1 Temp:   +43 C  (high =  -124 C, hyst =   +16 C)   sensor = transistor   ALARM   
AGP Temp:  +49.5 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
DDR Temp:  +46.0 C  (high =   +80 C, hyst =   +75 C)   sensor = transistor           
alarms:   Chassis intrusion detection                      ALARM
beep_enable:
          Sound alarm disabled

bear:~/hwmon# exit

Script done on Wed Aug  8 16:43:20 2007

On Tue, Aug 07, 2007 at 09:03:16PM -0400, Mark M. Hoffman wrote:
> Hi Joerg:
> 
> (I tried to follow-up using the gmane.org mail/news gateway... didn't seem
> to work.)
> 
> * Joerg Sommrey <jo@sommrey.de> [2007-08-05 12:26:04 +0200]:
> > Hi,
> > 
> > after upgrading from 2.6.21 to 2.6.22 the CPU temperatures shown by
> > w83781d look unreal.  They were in a range from 40°C when idle to
> > 75°C under full load with 2.6.21.  The values shown now are in a very
> > small range from 77°C to 82°C.  From the (low) noise of the fan I can
> > tell that the temperature is <50°C.
> > The third temperature shown is completely wrong.
> > 
> > I have a Tyan Tiger MPX board with a w83782d chip. Output from
> > "sensors":
> > 
> > w83782d-i2c-0-2d
> > Adapter: SMBus AMD768 adapter at 80e0
> >  +5 V:     +4.81 V  (min =  +4.76 V, max =  +5.24 V)
> > 3 VSB:     +3.30 V  (min =  +2.85 V, max =  +3.15 V)       ALARM
> > chs3 Fan: 2122 RPM  (min = 2657 RPM, div = 4)              ALARM
> > VRM2 Temp:  -208°C  (high =  -176°C, hyst =  -181°C)   sensor = transistor 
> > CPU1 Temp: +78.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
> > CPU2 Temp: +77.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
> > alarms:
> > beep_enable:
> >           Sound alarm enabled
> > 
> > # cat /sys/bus/i2c/devices/0-002d/temp*_input
> > -209000
> > 77500
> > 77500
> > 
> > Any ideas?
> 
> Please run the following commands as root (against both kernel versions) and
> reply-to-all with the results:
> 
> 	# modprobe i2c-dev
> 	# i2cdump -y 0 0x2d b 0 0x4e
> 	# i2cdump -y 0 0x48
> 	# i2cdump -y 0 0x49
> 
> Also, can you confirm that you're using the sensors.conf from here:
> http://www.tyan.com/support_download_utility.aspx?model=s.s2466
> 
> Finally, can you confirm that "sensors -s" is running (without error) some
> time during system startup, w/ both kernel versions?
> 
> Thanks & regards,
> 
> -- 
> Mark M. Hoffman
> mhoffman@lightlink.com
> 
