Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbZDJBB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbZDJBB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZDJBBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:01:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52923 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZDJBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:01:13 -0400
Date: Thu, 9 Apr 2009 18:03:19 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible
	ptrace issue?)
Message-ID: <20090410010319.GA2354@us.ibm.com>
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com> <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org> <20090409213910.GB30645@us.ibm.com> <B6C30A35-DBF7-4710-9F03-9E42775CDA21@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B6C30A35-DBF7-4710-9F03-9E42775CDA21@kernel.crashing.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> -bash-3.2# ps
>  PID TTY          TIME CMD
> 2289 ttyS0    00:00:00 bash
> 2310 ttyS0    00:00:00 runltp
> 2412 ttyS0    00:00:00 pan
> 2448 ttyS0    00:00:00 recv01 <defunct>
> 2450 ttyS0    00:00:00 recvfrom01 <defunct>
> 2452 ttyS0    00:00:00 recvmsg01 <defunct>
> 2473 ttyS0    00:00:00 rename14
> 2474 ttyS0    00:00:01 rename14
> 2477 ttyS0    00:00:00 rename14
> 2481 ttyS0    00:00:00 ps
> -bash-3.2# cat /proc/1/status
> Name:   init
> State:  T (stopped)

init is in the stopped state.  Can you run "kill -CONT 1" ?

> Tgid:   1
> Pid:    1
> PPid:   0
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> FDSize: 32
> Groups:
> VmPeak:     1948 kB
> VmSize:     1944 kB
> VmLck:         0 kB
> VmHWM:       648 kB
> VmRSS:       648 kB
> VmData:      164 kB
> VmStk:        84 kB
> VmExe:       288 kB
> VmLib:      1124 kB
> VmPTE:        20 kB
> Threads:        1
> SigQ:   8/16384
> SigPnd: 0000000000000000
> ShdPnd: 0000000000010000

Init does have the pending SIGCHLD, so the zombies should go away 
when init gets the SIGCONT.
