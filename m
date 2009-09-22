Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZIVK7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZIVK7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZIVK7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:59:44 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:15491 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZIVK7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:59:44 -0400
X-SourceIP: 213.93.53.227
Subject: Re: mailing list for trace users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4AB89520.2050900@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 12:59:39 +0200
Message-Id: <1253617179.7695.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:13 +0300, Avi Kivity wrote:
> 
> Yes please.  Here's a question to start it off - how to I 'perf 
> annotate' a symbol in a module?
> 
> $ perf report
> # Samples: 68202
> #
> # Overhead          Command  Shared Object  Symbol
> # ........  ...............  .............  ......
> #
>      84.17%  qemu-system-x86  [kernel]       [k] vmx_vcpu_run
> [kvm_intel]
>       4.28%  qemu-system-x86  [kernel]       [k]
> kvm_arch_vcpu_ioctl_run 
> [kvm]
>       0.88%  qemu-system-x86  [kernel]       [k] add_preempt_count
>       0.75%  qemu-system-x86  [kernel]       [k]
> _spin_unlock_irqrestore
>       0.68%  qemu-system-x86  [kernel]       [k] _spin_lock_irq
> 
> $ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
>   Error: symbol 'vmx_vcpu_run' not present amongst the samples.
> 
> builtin symbols work.

We need a /proc/modules parser that then also locates and loads .ko
files which aren't stripped.

I think Mike played around with that a bit.

The typical problem is that people use 'make INSTALL_MOD_STRIP=1
modules_install' to install their modules, because otherwise the initrd
thingies explode, the side effect is that the !initrd modules are
stripped too.

Ideally initrd tools should strip whatever they stick in. Then again,
ideally we'd not have any initrd and modules crap to begin with ;-)

