Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYAVIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYAVIkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYAVIkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:40:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbYAVIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:40:07 -0500
Date: Tue, 22 Jan 2008 00:40:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.24-rc8-mm1 (KVM build issues)
Message-Id: <20080122004004.a576acca.akpm@linux-foundation.org>
In-Reply-To: <20080118172632.GB12009@balbir.in.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080118172632.GB12009@balbir.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 18 Jan 2008 22:56:32 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Andrew Morton <akpm@linux-foundation.org> [2008-01-17 02:35:14]:
> 
> > - kvm probably doesn't work properly because I couldn't be bothered fixing
> >   the conflicts between git-kvm and the driver tree
> > 
> 
> Hi, Andrew,
> 
> The following changes got KVM up and running for me
> 
> 
> This patch fixes the kvm build on 2.6.24-rc8-mm1. First of all, it enables
> the KVM build, the second fix moves kset_set_name to the .name member.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/Makefile   |    2 +-
>  virt/kvm/kvm_main.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN arch/x86/Makefile~fix-kvm-build arch/x86/Makefile
> --- linux-2.6.24-rc8/arch/x86/Makefile~fix-kvm-build	2008-01-18 22:42:41.000000000 +0530
> +++ linux-2.6.24-rc8-balbir/arch/x86/Makefile	2008-01-18 22:42:47.000000000 +0530
> @@ -185,7 +185,7 @@ core-y += arch/x86/vdso/
>  core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
>  
>  # kvm host support - uncomment when merging
> -# core-$(CONFIG_KVM) += arch/x86/kvm/
> +core-$(CONFIG_KVM) += arch/x86/kvm/
>  
>  # drivers-y are linked after core-y
>  drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
> diff -puN virt/kvm/kvm_main.c~fix-kvm-build virt/kvm/kvm_main.c
> --- linux-2.6.24-rc8/virt/kvm/kvm_main.c~fix-kvm-build	2008-01-18 22:42:41.000000000 +0530
> +++ linux-2.6.24-rc8-balbir/virt/kvm/kvm_main.c	2008-01-18 22:42:47.000000000 +0530
> @@ -1260,7 +1260,7 @@ static int kvm_resume(struct sys_device 
>  }
>  
>  static struct sysdev_class kvm_sysdev_class = {
> -	set_kset_name("kvm"),
> +	.name = "kvm",
>  	.suspend = kvm_suspend,
>  	.resume = kvm_resume,
>  };

This patch straddles such a pickle of other patches (driver tree, kvm, git-x86) that
there doesn't seem much point in me untangling it.  Presumably people will fix things
up as various trees merge into 2.6.25-rc1.

As long as Greg remembers to try to build kvm ;)
