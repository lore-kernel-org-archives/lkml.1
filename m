Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZHDOR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZHDOR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZHDOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:17:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZHDORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:17:25 -0400
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <46C99371.7070705@bull.net>
References: <46C99371.7070705@bull.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Aug 2009 16:16:38 +0200
Message-Id: <1249395398.7924.223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches never seem to have made it onto LKML?!

On Mon, 2007-08-20 at 15:13 +0200, Laurent Vivier wrote:
> The aim of these four patches is to introduce Virtual Machine time accounting.
> 
> _Ingo_, as these patches modify files of the scheduler, could you have a look to
> them, please ?
> 
> [PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
> "system", we need a new field, "guest", in cpustat to store the time used by
> the CPU to run virtual CPU. Modify /proc/stat to display this new field.
> 
> [PATCH 2/4] like for cpustat, introduce the "gtime" (guest time of the task) and
> "cgtime" (guest time of the task children) fields for the
> tasks. Modify signal_struct and task_struct. Modify /proc/<pid>/stat to display
> these new fields.
> 
> [PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
> are running a VCPU. We add this cputime to  cpustat->user instead of
> cpustat->system because this part of KVM code is in fact user code although it
> is executed in the kernel. We duplicate VCPU time between guest and user to
> allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
> able to display good cpu user time and cpu guest time by subtracting cpu guest
> time from cpu user time. Update "gtime" and "cgtime" in signal_struct and
> task_struct accordingly.
> 
> [PATCH 4/4] Modify KVM to update guest time accounting.

Isn't this exactly what CONFIG_VIRT_CPU_ACCOUNTING is about?
