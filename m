Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXIKNB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXIKNB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXIKNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:01:45 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:56989 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbXIKNBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:01:44 -0400
Date: Tue, 11 Sep 2007 15:01:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
Message-Id: <20070911150143.c2bc4cf3.dada1@cosmosbay.com>
In-Reply-To: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 11:30:38 +0200
"Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de> wrote:

> Hi,
> 
> since upgrading from SLES9 SP3 to SLES10 SP1 I see kernel segfaults which seem 
> network-related: Most notably slapd does not run any more, and my sendmail-milter 
> based virus scanner terminates now and then with kernel segfault.
> 
> Current kernel form SLES10 SP1 is: 
> 
> # cat /proc/version
> Linux version 2.6.16.53-0.8-smp (geeko@buildhost) (gcc version 4.1.2 20070115 
> (prerelease) (SUSE Linux)) #1 SMP Fri Aug 31 13:07:27 UTC 2007
> 
> The effects in syslog are:
> Aug 31 15:04:40 kgate1 kernel: powersaved[10102]: segfault at 0000000000000008 rip 
> 000000000042c17a rsp 00007fffea55de00 error 4
> Aug 31 15:14:57 kgate1 kernel: slapd[5296]: segfault at 0000555555981000 rip 
> 00002ad35ffee46b rsp 00007fff4bf58c28 error 4
> Aug 31 15:17:13 kgate1 kernel: powersaved[4747]: segfault at 0000000000000008 rip 
> 000000000042c17a rsp 00007ffff434e260 error 4
> Aug 31 17:50:48 kgate1 kernel: slapd[5561]: segfault at 0000555555986000 rip 
> 00002b8fa3cf3483 rsp 00007fff08252808 error 4
> Sep  3 09:02:04 kgate1 kernel: slapd[22654]: segfault at 0000555555992000 rip 
> 00002afd6f7b4483 rsp 00007fff3c790458 error 4
> Sep  3 13:14:45 kgate1 kernel: slapd[28324]: segfault at 0000555555962000 rip 
> 00002b5c0ae00483 rsp 00007fffa1144e58 error 4
> Sep  7 07:48:26 kgate1 kernel: hscan[1142]: segfault at 0000000000000003 rip 
> 00002afac0581650 rsp 0000000041000928 error 4
> Sep  7 09:12:24 kgate1 kernel: slapd[6022]: segfault at 00005555559b3000 rip 
> 00002b1c15539483 rsp 00007fff96a0c978 error 4
> Sep 10 17:02:35 kgate1 kernel: hscan[6795]: segfault at 0000000000000004 rip 
> 00002b59c0300650 rsp 0000000042002928 error 4
> Sep 11 08:43:43 kgate1 kernel: hscan[3456]: segfault at 0000000000000004 rip 
> 00002adcd625d650 rsp 0000000043004928 error 4
> Sep 11 10:45:38 kgate1 kernel: hscan[28343]: segfault at 0000000000000003 rip 
> 00002b17020de650 rsp 0000000042803928 error 4
> 
> I know that this kind of report is not very helpful to you guys, but Novell does 
> not allow me to report a kernel bug directly. (I've told the person who may to do 
> so, but I'm unsure whether something is in progress already).
> 
> Also note that the i586 (32-bit, non-SMP) kernel does not have that problem.
> Linux version 2.6.16.53-0.8-default (geeko@buildhost) (gcc version 4.1.2 20070115 
> (prerelease) (SUSE Linux)) #1 Fri Aug 31 13:07:27 UTC 2007

Are you sure ?

segfaulting are sysloged only on 64bits kernel.

Maybe your slapd/hscan processes are doing bad things, that make them 
core dump without notice on a 32bits kernel.

Eric
