Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbXCEQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbXCEQNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXCEQNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:13:23 -0500
Received: from pat.uio.no ([129.240.10.15]:33106 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXCEQNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:13:22 -0500
Subject: Re: Nfs over tcp retries
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andy Chittenden <andyc@bluearc.com>
Cc: linux-kernel@vger.kernel.org,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com>
References: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 11:13:08 -0500
Message-Id: <1173111188.6470.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.150)
X-UiO-Scanned: CFD0ACCD7F56415CF64912B74387E05C347D0A22
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 319 total 250017 max/h 2760 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 10:42 +0000, Andy Chittenden wrote:
> Here's a sequence of packets captured at the end of a NFS connection and
> the start of the next for a RH Fedora Core 6 client:
> 
> # cat ~/tmp/28852a.txt
> No.     Time        Source                Destination           Protocol
> Info
>       1 0.000000    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [ACK] Seq=4104776783 Ack=146337374 Win=5840 Len=1460
>       2 0.000009    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [PSH, ACK] Seq=4104778243 Ack=146337374 Win=5840
> Len=1244[Packet size limited during capture]
>       3 0.000031    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [FIN, ACK] Seq=146337374 Ack=4104776783 Win=64240 Len=0
>       4 0.000210    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [ACK] Seq=146337375 Ack=4104779487 Win=64240 Len=0
>       5 0.000226    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [ACK] Seq=4104779487 Ack=146337375 Win=5840 Len=0
>       6 0.002454    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [FIN, ACK] Seq=4104779487 Ack=146337375 Win=5840 Len=0
>       7 0.002651    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [ACK] Seq=146337375 Ack=4104779488 Win=64240 Len=0
>       8 0.003601    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775174 Len=0 MSS=1460 TSV=110286926 TSER=0 WS=7
>       9 0.003709    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775175 Win=64240 Len=0
>      10 3.003081    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775177 Len=0 MSS=1460 TSV=110287676 TSER=0 WS=7
>      11 3.003196    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775178 Win=64240 Len=0
>      12 9.003738    192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775180 Len=0 MSS=1460 TSV=110289176 TSER=0 WS=7
>      13 9.003852    192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775181 Win=64240 Len=0
>      14 21.004805   192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775183 Len=0 MSS=1460 TSV=110292177 TSER=0 WS=7
>      15 21.004917   192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775184 Win=64240 Len=0
>      16 45.007926   192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775186 Len=0 MSS=1460 TSV=110298177 TSER=0 WS=7
>      17 45.008050   192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775187 Win=64240 Len=0
>      18 93.005802   192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775189 Len=0 MSS=1460 TSV=110310177 TSER=0 WS=7
>      19 93.005933   192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775190 Win=64240 Len=0
>      20 189.009560  192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775192 Len=0 MSS=1460 TSV=110334177 TSER=0 WS=7
>      21 189.009675  192.168.38.218        192.168.37.10         TCP
> nfs > 894 [RST, ACK] Seq=146337375 Ack=4104775193 Win=64240 Len=0
>      22 381.013870  192.168.37.10         192.168.38.218        TCP
> 894 > nfs [SYN] Seq=4104775195 Len=0 MSS=1460 TSV=110382178 TSER=0 WS=7
>      23 381.013980  192.168.38.218        192.168.37.10         TCP
> [TCP Previous segment lost] nfs > 894 [SYN, ACK] Seq=240134139
> Ack=4104775196 Win=64240 Len=0 MSS=1460
>      24 381.014010  192.168.37.10         192.168.38.218        TCP
> 894 > nfs [ACK] Seq=4104775196 Ack=240134140 Win=5840 Len=0
> 
> As you can see in packet 3, the nfs server's sent a FIN-ACK which is
> acknowledged in packet 6 by the client. So by packet 8, the connection's
> closed. The client attempts to reconnect to the server in packet 8 which
> is refused by the server in packet 9 as the client is using the same
> port number as the previous session: the server's in TIME WAIT from the
> previous connection and the initial send sequence number of this new
> connection is below the highest sequence number of the previous
> connection. The client's attempts to reconnect continue unsuccessfully
> until 2MSL is exceeded.

Why is the server disconnecting from the client in the first place? That
seems odd...

> So, a few questions:
> 
> * why does the NFS client reuse the same source port number (894 in the
> example above)?

Servers commonly implement duplicate request caches that depend on a
combination of the XID, port number RPC program number and RPC procedure
number (See http://www.connectathon.org/talks96/werme1.html). In order
for that to work, the clients have to obey the convention that they
reuse port numbers as well as XIDs when replaying a request.

> * if the socket's being reused, why is the ISS being chosen such that
> it's within the same range as the last successful connection?
> * why does the ISS seem to go up by only 3 since the last attempt to
> connect?
> 
> If the linux NFS client had used a different source port number or
> chosen an out-of-range ISS, then its reconnection attempts would have
> been successful in a more timely manner.

What does Solaris do in the same situation?

Cheers
  Trond

