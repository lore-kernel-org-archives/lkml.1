Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbXF1VYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbXF1VYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXF1VX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:23:57 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:15969 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761166AbXF1VX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JDTRxsVi7LbeR9lFUHV6+hpxFI+2rbUSDgXYtjzgojkBSXrY/L7PfQZm8A4mNW9PPuxrGVkgFWTmt/PrlgWDIXT/Kppa9Nzw76A6yONBUSIWKXgr0x9+c8i4wRjbAZ/QBtJIy9ch9+0FmZmxu3VolUqxAB6tc5KYUSmPQuwOSPU=
Message-ID: <e9c3a7c20706281423p27059e90qe7f986d7485753a7@mail.gmail.com>
Date: Thu, 28 Jun 2007 14:23:54 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.58.0706281632510.27157@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
	 <1182823276.5493.240.camel@localhost.localdomain>
	 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
	 <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
	 <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com>
	 <Pine.LNX.4.58.0706281632510.27157@gandalf.stny.rr.com>
X-Google-Sender-Auth: d57e5bc6e8ca904d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 28 Jun 2007, Dan Williams wrote:
> > >
> > Unfortunately setting the thread to real time priority makes
> > throughput slightly worse.  Instead of floating around 35MB/s the
> > resync speed is stuck around 30MB/s:
>
> That is really strange. If you higher the prio of the work queue it
> gets worst?  Something really strange is happening here?  Are you using
> CONFIG_PREEMPT?
>
Everything thus far has been CONFIG_PREEMPT=n (the default for this platform).

With CONFIG_PREEMPT=y the resync is back in the 50MB/s range.

[iop-adma: hi-prio workqueue, CONFIG_PREEMPT=y]
iq81340mc:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
      468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [=>...................]  recovery =  5.8% (9136404/156290816)
finish=46.1min speed=53161K/sec

The tasklet configuration stays in 50MB/s ballpark, and the default
priority (nice -5) workqueue case remains in the 30's with
CONFIG_PREEMPT=n.

--
Dan
