Return-Path: <linux-kernel-owner+w=401wt.eu-S1946017AbXBICYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946017AbXBICYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946024AbXBICYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:24:03 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38401 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946017AbXBICYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:24:00 -0500
Date: Fri, 9 Feb 2007 03:22:25 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Christopher R. Hertel" <crh@ubiqx.mn.org>
cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
In-Reply-To: <45CBC5F0.7080907@ubiqx.mn.org>
Message-ID: <Pine.LNX.4.61.0702090321110.8587@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>
 <45CBC072.90102@ubiqx.mn.org> <Pine.LNX.4.61.0702090130440.8587@yvahk01.tjqt.qr>
 <45CBC5F0.7080907@ubiqx.mn.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Feb 8 2007 18:53, Christopher R. Hertel wrote:
>>>
>>> It does seem to me that it is some sort of name resolution issue, but it may
>>> have more to do with the multi-homed nature of your setup.
>>>
>>> Did you try:
>>>
>>>  mount.cifs //CL0/c /mnt
>> 
>> Yes, that one _fails_ with "mount error 112 = Host is down" (though tcpdump
>> _does_ show that cifs connects to port 139 and then disconnects using FIN)
>
>It would be interesting to see that capture.

01:39:02.089070 IP 192.168.222.94.2019 > 192.168.222.33.445: S 870214128:870214128(0) win 5840 <mss 1460,sackOK,timestamp 828349 0,nop,wscale 1>
	0x0000:  4500 003c ca4d 4000 4006 329d c0a8 de5e  E..<.M@.@.2....^
	0x0010:  c0a8 de21 07e3 01bd 33de 69f0 0000 0000  ...!....3.i.....
	0x0020:  a002 16d0 a82c 0000 0204 05b4 0402 080a  .....,..........
	0x0030:  000c a3bd 0000 0000 0103 0301            ............
01:39:02.092572 IP 192.168.222.33.445 > 192.168.222.94.2019: R 0:0(0) ack 870214129 win 0
	0x0000:  4500 0028 f300 0000 8006 09fe c0a8 de21  E..(...........!
	0x0010:  c0a8 de5e 01bd 07e3 0000 0000 33de 69f1  ...^........3.i.
	0x0020:  5014 0000 ca8f 0000 0000 0000 0000       P.............
01:39:02.096738 IP 192.168.222.94.1343 > 192.168.222.33.139: S 870214131:870214131(0) win 5840 <mss 1460,sackOK,timestamp 828352 0,nop,wscale 1>
	0x0000:  4500 003c ca33 4000 4006 32b7 c0a8 de5e  E..<.3@.@.2....^
	0x0010:  c0a8 de21 053f 008b 33de 69f3 0000 0000  ...!.?..3.i.....
	0x0020:  a002 16d0 abfc 0000 0204 05b4 0402 080a  ................
	0x0030:  000c a3c0 0000 0000 0103 0301            ............
01:39:02.102544 IP 192.168.222.33.139 > 192.168.222.94.1343: S 4435509:4435509(0) ack 870214132 win 8760 <mss 1460,nop,nop,sackOK>
	0x0000:  4500 0030 f400 4000 8006 c8f5 c0a8 de21  E..0..@........!
	0x0010:  c0a8 de5e 008b 053f 0043 ae35 33de 69f4  ...^...?.C.53.i.
	0x0020:  7012 2238 d0f0 0000 0204 05b4 0101 0402  p."8............
01:39:02.104880 IP 192.168.222.94.1343 > 192.168.222.33.139: . ack 1 win 5840
	0x0000:  4500 0028 ca34 4000 4006 32ca c0a8 de5e  E..(.4@.@.2....^
	0x0010:  c0a8 de21 053f 008b 33de 69f4 0043 ae36  ...!.?..3.i..C.6
	0x0020:  5010 16d0 091d 0000                      P.......
01:39:02.117326 IP 192.168.222.94.1343 > 192.168.222.33.139: P 1:73(72) ack 1 win 5840 NBT Session Packet: Session Request
	0x0000:  4500 0070 ca35 4000 4006 3281 c0a8 de5e  E..p.5@.@.2....^
	0x0010:  c0a8 de21 053f 008b 33de 69f4 0043 ae36  ...!.?..3.i..C.6
	0x0020:  5018 16d0 3e34 0000 8100 0044 2043 4b46  P...>4.....D.CKF
	0x0030:  4445 4e45 4346 4445 4646 4346 4745 4646  DENECFDEFFCFGEFF
	0x0040:  4343 4143 4143 4143 4143 4143 4100 2046  CCACACACACACA..F
	0x0050:  4445 4c44 4143 4143 4143 4143 4143 4143  DELDACACACACACAC
	0x0060:  4143 4143 4143 4143 4143 4143 4141 4100  ACACACACACACAAA.
01:39:02.121140 IP 192.168.222.33.139 > 192.168.222.94.1343: FP 1:6(5) ack 73 win 8688 NBT Session Packet: [|SMB]
	0x0000:  4500 002d f500 4000 8006 c7f8 c0a8 de21  E..-..@........!
	0x0010:  c0a8 de5e 008b 053f 0043 ae36 33de 6a3c  ...^...?.C.63.j<
	0x0020:  5019 21f0 f8a4 0000 8300 0001 8253       P.!..........S
01:39:02.162638 IP 192.168.222.94.1343 > 192.168.222.33.139: . ack 7 win 5840
	0x0000:  4500 0028 ca36 4000 4006 32c8 c0a8 de5e  E..(.6@.@.2....^
	0x0010:  c0a8 de21 053f 008b 33de 6a3c 0043 ae3c  ...!.?..3.j<.C.<
	0x0020:  5010 16d0 08cf 0000                      P.......
01:39:02.173013 IP 192.168.222.94.1343 > 192.168.222.33.139: P 73:155(82) ack 7 win 5840 NBT Session Packet: Session Message
	0x0000:  4500 007a ca37 4000 4006 3275 c0a8 de5e  E..z.7@.@.2u...^
	0x0010:  c0a8 de21 053f 008b 33de 6a3c 0043 ae3c  ...!.?..3.j<.C.<
	0x0020:  5018 16d0 3e3e 0000 0000 004e ff53 4d42  P...>>.....N.SMB
	0x0030:  7200 0000 0000 0180 0000 0000 0000 0000  r...............
	0x0040:  0000 0000 0000 950d 0000 0100 002b 0002  .............+..
	0x0050:  4c4d 312e 3258 3030 3200 024c 414e 4d41  LM1.2X002..LANMA
	0x0060:  4e32 2e31 0002 4e54 204c 4d20 302e 3132  N2.1..NT.LM.0.12
	0x0070:  0002 504f 5349 5820 3200                 ..POSIX.2.
01:39:02.317447 IP 192.168.222.94.1343 > 192.168.222.33.139: R 155:155(0) ack 7 win 5840
	0x0000:  4500 0028 ca38 4000 4006 32c6 c0a8 de5e  E..(.8@.@.2....^
	0x0010:  c0a8 de21 053f 008b 33de 6a8e 0043 ae3c  ...!.?..3.j..C.<
	0x0020:  5014 16d0 0879 0000                      P....y..



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
