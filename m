Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYEIWma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYEIWma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYEIWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:42:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:4222 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYEIWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NEmBGoveGjT5duaaObnHCs1ZdghAz8m3KMF4D4PuL0PRyOeK0DJuDvAUq/qROz/cR6xhppvjNOnAVanthSIt381D96ANTcy32LQFIGKp4xtcjl1Kq0EYSryn+IXLd2VL6J5PD2kFPjbGBo/WNfcOvFHTrl+DVS+S1R6YdIVqQ9Q=
Date: Sat, 10 May 2008 03:37:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080509233742.GA22265@martell.zuzino.mipt.ru>
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4824AD3C.3070506@grupopie.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 08:59:56PM +0100, Paulo Marques wrote:
> Andi Kleen wrote:
>>>> ffffffff80337043 u idr_pre_get  [i2c_core]
>>>> ffffc2000007573e ? DW.sched.h.920090ff.56       [i2c_core]
>>> Are you compiling with CONFIG_KALLSYMS_ALL?
>> Yep.
>> CONFIG_KALLSYMS=y
>> CONFIG_KALLSYMS_ALL=y
>> # CONFIG_KALLSYMS_EXTRA_PASS is not set
>>> If you are, kallsyms will store all the output of "nm -n vmlinux" no
>>> matter what section the symbol belongs to...
>> Yes and? Surely that's not correct?
>
> That's not for me to judge, but I believe it has always been like that.

*cough*

Here is how typical /proc/kallsyms looks like:

ffffffff80200000 A _text
ffffffff80200000 T startup_64
ffffffff802000b7 t ident_complete
ffffffff80200100 T secondary_startup_64
ffffffff802001a0 T init_rsp
ffffffff802001a8 t bad_address
ffffffff80201000 T init_level4_pgt
ffffffff80202000 T level3_ident_pgt
ffffffff80203000 T level3_kernel_pgt
ffffffff80204000 T level2_fixmap_pgt
ffffffff80205000 T level1_fixmap_pgt
ffffffff80206000 T level2_ident_pgt
ffffffff80207000 T level2_kernel_pgt
ffffffff80208000 T level2_spare_pgt
ffffffff80209000 T _stext
ffffffff80209000 t run_init_process
ffffffff80209020 t init_post
ffffffff80209120 T name_to_dev_t
ffffffff802092a0 t hard_disable_TSC
ffffffff802092b0 t hard_enable_TSC
ffffffff802092c0 T arch_randomize_brk
ffffffff80209300 T arch_align_stack
ffffffff80209350 T do_arch_prctl
ffffffff80209760 T disable_TSC
ffffffff802097c0 T set_tsc_mode
ffffffff80209830 T sys_vfork
ffffffff80209860 T sys_clone
ffffffff80209890 T sys_fork
ffffffff802098c0 T sys_execve
ffffffff80209940 T release_thread
ffffffff80209980 T __show_regs
ffffffff80209bc0 T show_regs
ffffffff80209c10 t __exit_idle
ffffffff80209c40 T enter_idle
ffffffff80209c70 T idle_notifier_register
ffffffff80209c90 T exit_idle
ffffffff80209cc0 T set_personality_64bit
ffffffff80209cf0 T get_wchan
ffffffff80209da0 T sys_arch_prctl
ffffffff80209dc0 T __switch_to
ffffffff8020a140 T cpu_idle
ffffffff8020a1f0 T start_thread
ffffffff8020a290 T get_tsc_mode
ffffffff8020a2c0 T prepare_to_copy
ffffffff8020a320 T default_idle
ffffffff8020a370 T flush_thread
ffffffff8020a460 T exit_thread
ffffffff8020a520 T copy_thread
ffffffff8020a6e0 t get_stack
ffffffff8020a740 t current_syscall
	...

