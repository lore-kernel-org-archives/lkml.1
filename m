Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbXIKP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbXIKP5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXIKP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:57:28 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34437 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbXIKP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:57:27 -0400
Date: Tue, 11 Sep 2007 17:57:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
Message-Id: <20070911175724.e743febb.dada1@cosmosbay.com>
In-Reply-To: <46E6CD2F.1142.1554B48D@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
	<46E6CD2F.1142.1554B48D@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 17:15:26 +0200
"Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de> wrote:

> On 11 Sep 2007 at 15:01, Eric Dumazet wrote:
> 
> [...]
> > > Also note that the i586 (32-bit, non-SMP) kernel does not have that problem.
> > > Linux version 2.6.16.53-0.8-default (geeko@buildhost) (gcc version 4.1.2 20070115 
> > > (prerelease) (SUSE Linux)) #1 Fri Aug 31 13:07:27 UTC 2007
> > 
> > Are you sure ?
> 
> Not any more ;-)
> 
> > 
> > segfaulting are sysloged only on 64bits kernel.
> > 
> > Maybe your slapd/hscan processes are doing bad things, that make them 
> > core dump without notice on a 32bits kernel.
> 
> I'm using the senddmail milter library that does the socket communication. So any 
> bad things should be searched there.
> 
> I tend to think that the same program when being compiled as a 32-bit executable 
> does not cause these segfaults on a 64 bit kernel.
> 
> I also tried to use ksymoops to get a disassembly of the corresponding kernel 
> code, but the result did not look good to me.
> 
> Is there a deeper reason why the kernel does not provide more info (like a call 
> trace) on segfaults?
> 
> Will an strace of the program (multi-threaded, unfortunately, just as slapd (most 
> likely)) be helpful?
> 
> When I tried it for slapd, the (rest of the) strace was:
> 9931  socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 3
> 9931  connect(3, {sa_family=AF_INET, sin_port=htons(427), sin_addr=inet_addr("12
> 7.0.0.1")}, 16) = 0
> 9931  setsockopt(3, SOL_SOCKET, SO_RCVLOWAT, [18], 4) = 0
> 9931  setsockopt(3, SOL_SOCKET, SO_SNDLOWAT, [18], 4) = -1 ENOPROTOOPT (Protocol
>  not available)
> 9931  mmap(NULL, 1434435584, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1
> , 0) = 0x2aaaaae32000
> 9931  --- SIGSEGV (Segmentation fault) @ 0 (0) ---

Definitly a user mode problem, dereferencing a NULL pointer.

Try to attach gdb on this process instead of stracing it, then a "bt" command should 
tell you some usefull things.

Strange thing here is that this program wants a huge block of memory (1434435584 bytes),
so maybe some file is corrupted, maybe you should check database integrity first.

