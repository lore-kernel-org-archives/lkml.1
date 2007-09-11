Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbXIKPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbXIKPQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXIKPQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:16:09 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:23213 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbXIKPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:16:08 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 11 Sep 2007 17:15:26 +0200
MIME-Version: 1.0
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
CC: linux-kernel@vger.kernel.org
Message-ID: <46E6CD2F.1142.1554B48D@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <20070911150143.c2bc4cf3.dada1@cosmosbay.com>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.26/Sophos-P=4.19.0+V=4.19+U=2.07.173+R=02 July 2007+T=260007@20070911.151214Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Sep 2007 at 15:01, Eric Dumazet wrote:

[...]
> > Also note that the i586 (32-bit, non-SMP) kernel does not have that problem.
> > Linux version 2.6.16.53-0.8-default (geeko@buildhost) (gcc version 4.1.2 20070115 
> > (prerelease) (SUSE Linux)) #1 Fri Aug 31 13:07:27 UTC 2007
> 
> Are you sure ?

Not any more ;-)

> 
> segfaulting are sysloged only on 64bits kernel.
> 
> Maybe your slapd/hscan processes are doing bad things, that make them 
> core dump without notice on a 32bits kernel.

I'm using the senddmail milter library that does the socket communication. So any 
bad things should be searched there.

I tend to think that the same program when being compiled as a 32-bit executable 
does not cause these segfaults on a 64 bit kernel.

I also tried to use ksymoops to get a disassembly of the corresponding kernel 
code, but the result did not look good to me.

Is there a deeper reason why the kernel does not provide more info (like a call 
trace) on segfaults?

Will an strace of the program (multi-threaded, unfortunately, just as slapd (most 
likely)) be helpful?

When I tried it for slapd, the (rest of the) strace was:
9931  socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 3
9931  connect(3, {sa_family=AF_INET, sin_port=htons(427), sin_addr=inet_addr("12
7.0.0.1")}, 16) = 0
9931  setsockopt(3, SOL_SOCKET, SO_RCVLOWAT, [18], 4) = 0
9931  setsockopt(3, SOL_SOCKET, SO_SNDLOWAT, [18], 4) = -1 ENOPROTOOPT (Protocol
 not available)
9931  mmap(NULL, 1434435584, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1
, 0) = 0x2aaaaae32000
9931  --- SIGSEGV (Segmentation fault) @ 0 (0) ---

Regards,
Ulrich

