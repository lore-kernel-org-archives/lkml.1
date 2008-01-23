Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYAWESg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYAWESg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYAWEST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:18:19 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:55387 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbYAWESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EVHsUnD/3IqJ13u6hsiH1QBV/qKirmOD4U+UVvWN9043HGZJ0rjkTCCir8eQbcG5b2uRfos4rA1FxmoBawjyoz8+/oxPZUg+z9igiPEUOTCcM+95seyHDoBrC2gZLLYnwlETsun8VVDNixRDCnyqeexnCYeFf6Y2zquuuOhqKLM=
Message-ID: <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com>
Date: Wed, 23 Jan 2008 12:18:13 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] procfs: constify function pointer tables
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Bryan Wu" <bryan.wu@analog.com>, "Mikael Starvik" <starvik@axis.com>,
       "David Howells" <dhowells@redhat.com>,
       "Hirokazu Takata" <takata@linux-m32r.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kyle McMartin" <kyle@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, "Chris Zankel" <chris@zankel.net>
In-Reply-To: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
	 <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 4:00 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Hi,
>
>
> This touches so many different places that I did not feel like creating
> a miniscule patch for each architecture. I hope that is ok.
>
> ===Patch begins===
> [PATCH] procfs: constify function pointer tables
>
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  arch/alpha/kernel/setup.c     |    2 +-
>  arch/blackfin/kernel/setup.c  |    2 +-
>  arch/cris/kernel/setup.c      |    2 +-
>  arch/frv/kernel/setup.c       |    2 +-
>  arch/h8300/kernel/setup.c     |    2 +-
>  arch/m32r/kernel/setup.c      |    2 +-
>  arch/m68k/kernel/setup.c      |    2 +-
>  arch/m68knommu/kernel/setup.c |    2 +-
>  arch/parisc/kernel/setup.c    |    2 +-
>  arch/ppc/kernel/setup.c       |    2 +-
>  arch/v850/kernel/procfs.c     |    2 +-
>  arch/xtensa/kernel/setup.c    |    2 +-
>  fs/proc/base.c                |    6 +++---
>  fs/proc/nommu.c               |    2 +-
>  fs/proc/proc_misc.c           |   22 +++++++++++-----------
>  fs/proc/proc_sysctl.c         |    4 ++--
>  fs/proc/proc_tty.c            |    2 +-
>  fs/proc/task_mmu.c            |    8 ++++----
>  fs/proc/task_nommu.c          |    2 +-
>  19 files changed, 35 insertions(+), 35 deletions(-)
>
> diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
> index bd5e68c..823f18e 100644
> --- a/arch/alpha/kernel/setup.c
> +++ b/arch/alpha/kernel/setup.c
> @@ -1472,7 +1472,7 @@ c_stop(struct seq_file *f, void *v)
>  {
>  }
>
> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>         .start  = c_start,
>         .next   = c_next,
>         .stop   = c_stop,
> diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
> index d282201..d67cf54 100644
> --- a/arch/blackfin/kernel/setup.c
> +++ b/arch/blackfin/kernel/setup.c
> @@ -691,7 +691,7 @@ static void c_stop(struct seq_file *m, void *v)
>  {
>  }
>
> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>         .start = c_start,
>         .next = c_next,
>         .stop = c_stop,

Thanks, I understand the seq_xxx() API needs "const struct seq_operations *".
So for Blackfin part, I agree with Mike.

Acked-by: Bryan Wu <bryan.wu@analog.com>

but there are still some other files need add "const":
---
/opt/git-tree/blackfin-2.6$ grep -r seq_operations arch/*
arch/alpha/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/arm/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/arm/mach-davinci/clock.c:static struct seq_operations davinci_ck_op = {
arch/avr32/kernel/cpu.c:struct seq_operations cpuinfo_op = {
arch/avr32/mm/tlb.c:static struct seq_operations tlb_ops = {
arch/blackfin/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/cris/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/frv/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/h8300/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/ia64/hp/common/sba_iommu.c:static struct seq_operations ioc_seq_ops = {
arch/ia64/kernel/perfmon.c:struct seq_operations pfm_seq_ops = {
arch/ia64/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/ia64/sn/kernel/sn2/sn2_smp.c:static struct seq_operations
sn2_ptc_seq_ops = {
arch/ia64/sn/kernel/sn2/sn_hwperf.c:static struct seq_operations
sn_topology_seq_ops = {
arch/m32r/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/m68k/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/m68knommu/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/mips/kernel/proc.c:struct seq_operations cpuinfo_op = {
arch/parisc/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/powerpc/kernel/setup-common.c:struct seq_operations cpuinfo_op = {
----

[!snip!]

Regards,
-Bryan
