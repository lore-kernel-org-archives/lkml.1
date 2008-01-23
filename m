Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYAWKmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYAWKmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYAWKlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:41:52 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:29333 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYAWKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qAnDZxYJoV0wRAW/Yay9AEN0cdmZZ0A9i0BH8gWThnQc+c3L7eZEkwzXtlz7oZi/KRm0wpyt7hOhYW+6cX9jqBqE7+xnsi3X9KxvMLF/CKcqy1vMKSNvcILrpVU2o3yUBJe/bmBGpoeUU9HRErYVxIel134+FUfsgMGn3F6PS5w=
Message-ID: <386072610801230241h750ea592h9658b14fd2aa7058@mail.gmail.com>
Date: Wed, 23 Jan 2008 18:41:48 +0800
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
In-Reply-To: <Pine.LNX.4.64.0801231005090.12676@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
	 <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
	 <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com>
	 <Pine.LNX.4.64.0801231005090.12676@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 5:06 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 23 2008 12:18, Bryan Wu wrote:
> >> [PATCH] procfs: constify function pointer tables
> >> ---
> >>  arch/alpha/kernel/setup.c     |    2 +-
> >>  arch/blackfin/kernel/setup.c  |    2 +-
> >>  [...]
> >> diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
> >> index bd5e68c..823f18e 100644
> >> --- a/arch/alpha/kernel/setup.c
> >> +++ b/arch/alpha/kernel/setup.c
> >> @@ -1472,7 +1472,7 @@ c_stop(struct seq_file *f, void *v)
> >>  {
> >>  }
> >>
> >> -struct seq_operations cpuinfo_op = {
> >> +const struct seq_operations cpuinfo_op = {
> >>         .start  = c_start,
> >>         .next   = c_next,
> >>         .stop   = c_stop,
> [...]
> >Thanks, I understand the seq_xxx() API needs "const struct seq_operations *".
> >So for Blackfin part, I agree with Mike.
> >
> >but there are still some other files need add "const":
> >---
> >/opt/git-tree/blackfin-2.6$ grep -r seq_operations arch/*
> >arch/alpha/kernel/setup.c:struct seq_operations cpuinfo_op = {
>
> The patch already touches that :-)
>

Oh, this patch does not touch all, following is the missing list:
---
arch/arm/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/arm/mach-davinci/clock.c:static struct seq_operations davinci_ck_op = {
arch/avr32/kernel/cpu.c:struct seq_operations cpuinfo_op = {
arch/avr32/mm/tlb.c:static struct seq_operations tlb_ops = {
arch/ia64/hp/common/sba_iommu.c:static struct seq_operations ioc_seq_ops = {
arch/ia64/kernel/perfmon.c:struct seq_operations pfm_seq_ops = {
arch/ia64/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/ia64/sn/kernel/sn2/sn2_smp.c:static struct seq_operations
sn2_ptc_seq_ops = {
arch/ia64/sn/kernel/sn2/sn_hwperf.c:static struct seq_operations
sn_topology_seq_ops = {
arch/mips/kernel/proc.c:struct seq_operations cpuinfo_op = {
arch/powerpc/kernel/setup-common.c:struct seq_operations cpuinfo_op = {
arch/powerpc/platforms/pseries/hvCall_inst.c:static struct
seq_operations hcall_inst_seq_ops = {
arch/s390/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/sh/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/sh64/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/sparc/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/sparc64/kernel/setup.c:struct seq_operations cpuinfo_op = {
arch/x86/kernel/cpu/proc.c:struct seq_operations cpuinfo_op = {
arch/x86/kernel/setup_64.c:struct seq_operations cpuinfo_op = {
----

maybe you did not use the latest git tree.

-Bryan Wu
