Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYJMPgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYJMPgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYJMPgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:36:37 -0400
Received: from smtp3.ono.com ([62.42.230.176]:52676 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754656AbYJMPgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:36:36 -0400
Date: Mon, 13 Oct 2008 17:36:31 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu (less garbled this
 time)
Message-ID: <20081013173631.12c547d3@werewolf.home>
In-Reply-To: <1223900037856@dmwebmail.dmwebmail.chezphil.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
	<1223900037856@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 13:13:57 +0100, "Phil Endecott" <phil_wueww_endecott@chezphil.org> wrote:

> [Appoligies for the garbled first attempt at posting this.  Blame the
> original author for the long lines!?]
> 
> Am I right in thinking that CONFIG_MCORE2 is the correct choice for an 
> Intel Atom?  (It seems to work for me, so far.)  If this is true, since 
> there are quite a lot of these chips in circulation now and the choice 
> is not obvious, I think it would be helpful to add something along the 
> following lines to arch/x86/Kconfig.cpu.
> 
> Signed-off-by: Phil Endecott <kconfigcpu@chezphil.org>
> ---
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index b225219..7df0801 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -263,11 +263,12 @@ config MPSC
>            in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
> 
>   config MCORE2
> -       bool "Core 2/newer Xeon"
> +       bool "Core 2/newer Xeon/Atom"
>          help
> -         Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
> -         CPUs. You can distinguish newer from older Xeons by the CPU family
> -         in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
> +         Select this for Intel Core 2, newer Core 2 Xeon (Xeon 51xx and 53xx)
> +         and Intel Atom CPUs. You can distinguish newer from older Xeons by
> +         the CPU family in /proc/cpuinfo. Newer ones have 6 and older ones 15
> +         (not a typo).
> 
>   config GENERIC_CPU
>          bool "Generic-x86-64"
> 

I think Atom is worth a separate setting. It can share some flags with other
processors but has some very special features. And perhaps (I would like it)
distros begin to ship special 'netbook' kernels without all the extras you
don't need (raid, scsi adapters, etc...), with some tunes (iosched=nopp for
SSDs...), and memory scrapping settings (NR_CPUS=2 or 4...).

Some questions:
- How worthy is to reduce NR_CPUS from 64 (standard in many distros) to 2 or 4 ?
- Atom is an in-order processor. Intel included some flag in icc to build code
  with in-order scheduling, which will be the best settings in gcc ?
  From what I have found, apart from other things, -match=prescott is the best
  for Atom, wrt processor features. Perhaps the best settings are
    -march=prescott -mtune=generic
  until gcc people implement an in-order scheduler.
- Anyways, what does all this matter if Makefile_32.cpu reads:

cflags-$(CONFIG_MPENTIUMII) += -march=i686 $(call tune,pentium2)
cflags-$(CONFIG_MPENTIUMIII)    += -march=i686 $(call tune,pentium3)
cflags-$(CONFIG_MPENTIUMM)  += -march=i686 $(call tune,pentium3)
cflags-$(CONFIG_MPENTIUM4)  += -march=i686 $(call tune,pentium4)
cflags-$(CONFIG_MCORE2)     += -march=i686 $(call tune,core2)

ie, no march=xxxx ? Why don't we use something like

cflags-$(CONFIG_MCORE2)     += $(call cc-option,-march=core2,-march=i686) $(call tune,core2)

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
