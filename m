Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYAMDAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYAMDAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 22:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYAMDAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 22:00:36 -0500
Received: from tapir.sajinet.com.pe ([66.139.79.212]:56229 "EHLO
	tapir.sajinet.com.pe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYAMDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 22:00:35 -0500
Date: Sat, 12 Jan 2008 21:10:33 -0600
From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] boot stops after console handover?
Message-ID: <20080113031033.GA21813@tapir>
References: <47812BC3.6060503@nagafix.co.uk> <4781EDE3.2000008@qumranet.com> <47827DE4.2020306@nagafix.co.uk> <47833572.7090902@qumranet.com> <4783C6CC.1050404@nagafix.co.uk> <478901D7.1060404@nagafix.co.uk> <47892AA8.6090406@qumranet.com> <20080112222501.GA17084@tapir> <47896711.4050909@nagafix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47896711.4050909@nagafix.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 01:19:13AM +0000, Antoine Martin wrote:
> Carlo Marcelo Arenas Belon wrote:
> > On Sat, Jan 12, 2008 at 11:01:28PM +0200, Avi Kivity wrote:
> >> Antoine Martin wrote:
> >>
> >>> FYI, just tried building 2.6.24-rc7-git4 and got this warning:
> >>> (...)
> >> Probably harmless, but worth reporting to lkml.
> > 
> > couldn't replicate it here, but I'd seen usually those kind of errors
> > when building a kernel that hasn't been "mrproper" between re-configurations
> > 
> cp .config ../config-2.6.24-rc7-git4
> make mrproper
> cp ../config-2.6.24-rc7-git4 .config

make oldconfig  # presumed

> make -j 4

replicated with your configuration, but can't still reproduce it with mine
even when forcing as you do

  CONFIG_KVM=y
  CONFIG_KVM_INTEL=y

available from :

  http://tapir.sajinet.com.pe/kvm/config-2.6.24-rc7-git4

> (...)
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x2cb657): Section mismatch: reference to
> .init.text:register_cpu_notifier (between 'kvm_init_x86' and 'kvm_sched_in')
> WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to
> .init.data.2:trampoline_level4_pgt (between 'ident_complete' and
> 'secondary_startup_64')
> WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to
> .init.data.2:trampoline_level4_pgt (between 'ident_complete' and
> 'secondary_startup_64')
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
> 
> You can grab the .config here:
> http://194.145.196.85/kvm/config-2.6.24-rc7-git4

is this the configuration for the host kernel?

if you want to use the last code for kvm you should have CONFIG_KVM disabled
and instead use the external module as instructed in (HINT: you don't have a
patched kernel) :

  http://kvm.qumranet.com/kvmwiki/HOWTO1

not sure which version will be part of 2.6.24 but I suspect it might not be
kvm 59.

Carlo
