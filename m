Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbZHDQ0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbZHDQ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZHDQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:26:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbZHDQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:26:53 -0400
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Ingo Molnar <mingo@elte.hu>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20090804170747.11801f0a@skybase>
References: <46C99371.7070705@bull.net> <1249395398.7924.223.camel@twins>
	 <20090804170747.11801f0a@skybase>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 18:26:41 +0200
Message-Id: <1249403202.4762.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 17:07 +0200, Martin Schwidefsky wrote:
> On Tue, 04 Aug 2009 16:16:38 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > These patches never seem to have made it onto LKML?!
> > 
> > On Mon, 2007-08-20 at 15:13 +0200, Laurent Vivier wrote:
> > > The aim of these four patches is to introduce Virtual Machine time accounting.
> > > 
> > > _Ingo_, as these patches modify files of the scheduler, could you have a look to
> > > them, please ?
> > > 
> > > [PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
> > > "system", we need a new field, "guest", in cpustat to store the time used by
> > > the CPU to run virtual CPU. Modify /proc/stat to display this new field.
> > > 
> > > [PATCH 2/4] like for cpustat, introduce the "gtime" (guest time of the task) and
> > > "cgtime" (guest time of the task children) fields for the
> > > tasks. Modify signal_struct and task_struct. Modify /proc/<pid>/stat to display
> > > these new fields.
> > > 
> > > [PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
> > > are running a VCPU. We add this cputime to  cpustat->user instead of
> > > cpustat->system because this part of KVM code is in fact user code although it
> > > is executed in the kernel. We duplicate VCPU time between guest and user to
> > > allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
> > > able to display good cpu user time and cpu guest time by subtracting cpu guest
> > > time from cpu user time. Update "gtime" and "cgtime" in signal_struct and
> > > task_struct accordingly.
> > > 
> > > [PATCH 4/4] Modify KVM to update guest time accounting.
> > 
> > Isn't this exactly what CONFIG_VIRT_CPU_ACCOUNTING is about?
> 
> Not really, CONFIG_VIRT_CPU_ACCOUNT is a mechanism to sort out the
> steal time in the >guest< and to increase the precision of the cpu
> accounting values in general. The patches from Laurent improve the
> code in the >host< that sorts out guest time vs. system time.

Ah, that wasn't clear, it keeps mentioning guest all over the place ;-)

So its going to split user time into user and guest. Does that really
make sense? For the host kernel it really is just another user process,
no?

>  The patches do make sense to me.

No idea there as they never made it to my lkml folder.

