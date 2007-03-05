Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXCEKxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXCEKxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCEKxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:53:09 -0500
Received: from mx2.bluearc.com ([62.190.48.221]:4421 "EHLO
	uk-msw.terastack.bluearc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933080AbXCEKxI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:53:08 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 05:53:08 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Nfs over tcp retries
Date: Mon, 5 Mar 2007 10:42:53 -0000
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Nfs over tcp retries
Thread-Index: AcdfEwcqYT94Wis/Skm/RbIRXoC8xQ==
From: "Andy Chittenden" <andyc@bluearc.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a sequence of packets captured at the end of a NFS connection and
the start of the next for a RH Fedora Core 6 client:

# cat ~/tmp/28852a.txt
No.     Time        Source                Destination           Protocol
Info
      1 0.000000    192.168.37.10         192.168.38.218        TCP
894 > nfs [ACK] Seq=4104776783 Ack=146337374 Win=5840 Len=1460
      2 0.000009    192.168.37.10         192.168.38.218        TCP
894 > nfs [PSH, ACK] Seq=4104778243 Ack=146337374 Win=5840
Len=1244[Packet size limited during capture]
      3 0.000031    192.168.38.218        192.168.37.10         TCP
nfs > 894 [FIN, ACK] Seq=146337374 Ack=4104776783 Win=64240 Len=0
      4 0.000210    192.168.38.218        192.168.37.10         TCP
nfs > 894 [ACK] Seq=146337375 Ack=4104779487 Win=64240 Len=0
      5 0.000226    192.168.37.10         192.168.38.218        TCP
894 > nfs [ACK] Seq=4104779487 Ack=146337375 Win=5840 Len=0
      6 0.002454    192.168.37.10         192.168.38.218        TCP
894 > nfs [FIN, ACK] Seq=4104779487 Ack=146337375 Win=5840 Len=0
      7 0.002651    192.168.38.218        192.168.37.10         TCP
nfs > 894 [ACK] Seq=146337375 Ack=4104779488 Win=64240 Len=0
      8 0.003601    192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775174 Len=0 MSS=1460 TSV=110286926 TSER=0 WS=7
      9 0.003709    192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775175 Win=64240 Len=0
     10 3.003081    192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775177 Len=0 MSS=1460 TSV=110287676 TSER=0 WS=7
     11 3.003196    192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775178 Win=64240 Len=0
     12 9.003738    192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775180 Len=0 MSS=1460 TSV=110289176 TSER=0 WS=7
     13 9.003852    192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775181 Win=64240 Len=0
     14 21.004805   192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775183 Len=0 MSS=1460 TSV=110292177 TSER=0 WS=7
     15 21.004917   192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775184 Win=64240 Len=0
     16 45.007926   192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775186 Len=0 MSS=1460 TSV=110298177 TSER=0 WS=7
     17 45.008050   192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775187 Win=64240 Len=0
     18 93.005802   192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775189 Len=0 MSS=1460 TSV=110310177 TSER=0 WS=7
     19 93.005933   192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775190 Win=64240 Len=0
     20 189.009560  192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775192 Len=0 MSS=1460 TSV=110334177 TSER=0 WS=7
     21 189.009675  192.168.38.218        192.168.37.10         TCP
nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775193 Win=64240 Len=0
     22 381.013870  192.168.37.10         192.168.38.218        TCP
894 > nfs [SYN] Seq=4104775195 Len=0 MSS=1460 TSV=110382178 TSER=0 WS=7
     23 381.013980  192.168.38.218        192.168.37.10         TCP
[TCP Previous segment lost] nfs > 894 [SYN, ACK] Seq=240134139
Ack=4104775196 Win=64240 Len=0 MSS=1460
     24 381.014010  192.168.37.10         192.168.38.218        TCP
894 > nfs [ACK] Seq=4104775196 Ack=240134140 Win=5840 Len=0

As you can see in packet 3, the nfs server's sent a FIN-ACK which is
acknowledged in packet 6 by the client. So by packet 8, the connection's
closed. The client attempts to reconnect to the server in packet 8 which
is refused by the server in packet 9 as the client is using the same
port number as the previous session: the server's in TIME WAIT from the
previous connection and the initial send sequence number of this new
connection is below the highest sequence number of the previous
connection. The client's attempts to reconnect continue unsuccessfully
until 2MSL is exceeded.

So, a few questions:

* why does the NFS client reuse the same source port number (894 in the
example above)?
* if the socket's being reused, why is the ISS being chosen such that
it's within the same range as the last successful connection?
* why does the ISS seem to go up by only 3 since the last attempt to
connect?

If the linux NFS client had used a different source port number or
chosen an out-of-range ISS, then its reconnection attempts would have
been successful in a more timely manner.

-- 
Andy, BlueArc Engineering
