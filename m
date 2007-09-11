Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbXIKPzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbXIKPzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXIKPzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:55:05 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:29439 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278AbXIKPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:55:03 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 11 Sep 2007 17:54:38 +0200
MIME-Version: 1.0
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
CC: linux-kernel@vger.kernel.org
Message-ID: <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <20070911150143.c2bc4cf3.dada1@cosmosbay.com>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.26/Sophos-P=4.19.0+V=4.19+U=2.07.173+R=02 July 2007+T=260007@20070911.155218Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Sep 2007 at 15:01, Eric Dumazet wrote:

> On Tue, 11 Sep 2007 11:30:38 +0200
> "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de> wrote:
> 
> > Hi,
> > 
> > since upgrading from SLES9 SP3 to SLES10 SP1 I see kernel segfaults which seem 
> > network-related: Most notably slapd does not run any more, and my sendmail-milter 
> > based virus scanner terminates now and then with kernel segfault.
> > 
> > Current kernel form SLES10 SP1 is: 
> > 
> > # cat /proc/version
> > Linux version 2.6.16.53-0.8-smp (geeko@buildhost) (gcc version 4.1.2 20070115 
> > (prerelease) (SUSE Linux)) #1 SMP Fri Aug 31 13:07:27 UTC 2007
> > 
> > The effects in syslog are:
> > Aug 31 15:04:40 kgate1 kernel: powersaved[10102]: segfault at 0000000000000008 rip 
> > 000000000042c17a rsp 00007fffea55de00 error 4
[...]
> segfaulting are sysloged only on 64bits kernel.
> 
> Maybe your slapd/hscan processes are doing bad things, that make them 
> core dump without notice on a 32bits kernel.

A very wild guess: AFAIK SUSE Distributions are XENified recently, that is they 
have libraries that treat thread local storage differently from the default. If 
these programs (powersaved, slapd, hscan) are all multithreaded, could it be that 
the cause of the problem is in that area?

If not, any clues on debugging/tracing? There's a 
/usr/src/linux/Documentation/oops-tracing.txt, but no "segfault-tracing".

I also learned that the error code is only documented for i386 arch (thanks to 
Emacs ediff):
 * error_code:
 *      bit 0 == 0 means no page found, 1 means protection fault
 *      bit 1 == 0 means read, 1 means write
 *      bit 2 == 0 means kernel, 1 means user-mode

So the problem (error 4) looks a bit like a read on a NULL-pointer dereference, 
right? And the "rip" is user space, correct?

Regards,
Ulrich

