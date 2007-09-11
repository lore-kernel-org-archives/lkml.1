Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbXIKTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbXIKTwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbXIKTwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:52:06 -0400
Received: from www.osadl.org ([213.239.205.134]:53001 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932376AbXIKTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:52:04 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20070911114417.3f6e9e1b.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <200709111323.56030.rjw@sisk.pl>
	 <20070911042228.1ef690e0.akpm@linux-foundation.org>
	 <200709111409.13796.rjw@sisk.pl>
	 <20070911112531.80bac380.akpm@linux-foundation.org>
	 <1189535883.5235.13.camel@chaos>
	 <20070911114417.3f6e9e1b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 21:52:01 +0200
Message-Id: <1189540321.5235.21.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 11:44 -0700, Andrew Morton wrote:
> > > there doesn't seem to be a lot of difference in the time handling, except
> > > there are large changes in when things happen in the bootup sequence.
> > 
> > The question is whether the system goes into C2 with the patch applied.
> > 
> > Can you please provide the output of /proc/acpi/processor/CPU0/power for
> > both the bad and the good one ?
> > 
> 
> good:
> 
> sony:/home/akpm> cat /proc/acpi/processor/CPU0/power
> active state:            C0
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 8000 usec
> states:
>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000000] duration[00000000000000000000]
>     C2:                  type[C2] promotion[--] demotion[--] latency[001] usage[00000000] duration[00000000000000000000]
> 
> bad:
> 
> sony:/home/akpm> cat /proc/acpi/processor/CPU0/power
> active state:            C2
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 8000 usec
> states:
>     C1:                  type[C1] promotion[C2] demotion[--] latency[001] usage[00000010] duration[00000000000000000000]
>    *C2:                  type[C2] promotion[--] demotion[C1] latency[001] usage[00008316] duration[00000000000170717293]

Ok, here we are. The bad one uses C2 which stops the local apic on the
VAIO. I suspect we end up in the suspend/resume with going into C2
without the broadcast active.

Can you try to get the output of SysRq-Q during the "it needs help from
keyboard" period ?

	tglx




