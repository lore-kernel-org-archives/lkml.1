Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYIHOPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYIHOPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIHOPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:15:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:35436 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYIHOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CiP8IcoYZyJO2O7tYK91/X+OK5G85JQKX9ueKhR90muzQGb1csS/yIxjGIXv4XV8ZD
         dDN9bifIfdNmthjcZh6N3F23Nii11u+uYXumsSSBsEmNokZEXfmhqckaDyLQlr/MEW9A
         eHU/UFXaplSkXs2wsoOe9RUjWo2N4s8BB/c1E=
Message-ID: <921ca19c0809080715m6379b322x79edb239f6971560@mail.gmail.com>
Date: Mon, 8 Sep 2008 19:45:43 +0530
From: "Sujit Karataparambil" <sjt.kar@gmail.com>
Subject: Re: [PATCH] Convert tlbstate_lock spin_lock to raw_spin_lock
Cc: linux-rt-users@vger.kernel.org
In-Reply-To: <20080908073732.GC5798@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c6d8d720809071806i54e58093vf87bec5175d9b074@mail.gmail.com>
	 <20080908073732.GC5798@linux.vnet.ibm.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chirag,

  Kindly understand what xavier is trying to do. He is Trying to disable smp.
The RT - Linux Code is dependent on the mutex lock to perform some
soft/hard real time processing. This is an problem with the mutex lock.

Kindly check with some one before signing off patches.

Thanks,
Sujit


On 9/8/08, Chirag Jog <chirag@linux.vnet.ibm.com> wrote:
> * xavier droubay <xavier.droubay@gmail.com> [2008-09-08 03:06:51]:
>
> > Hello,
> >
> > I experienced this "rtmutex.c:743" known bug with rt3 patch, using
> >
> >  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.3.tar.bz2
> >  http://rt.et.redhat.com/download/patch-2.6.26.3-rt3.bz2
> >
> > I compiled this kernel with the "make-kpkg" debian utility.
> >
> > I first compiled this kernel with NO SMP, NO HIGHMEM, and partial ACPI
> > (without fan, processor, ... modules). Attached file
> > "config-2.6.26.3-rt3lowlty.frwr.gz".
> > I didn't experience any problem with this kernel.
> >
> > I then enabled SMP and HIGHMEM, and experienced  "rtmutex.c:743" BUG.
> > Attached files
> > "config-2.6.26.3-rt3rt-smp-hm.gz" and  "dmesg.gz" for some BUGGY message.
> >
> >
> > I have seen somewhere on the archive, that some people still
> > experienced problems with SMP.
> > I guess no fix has been done from rt3 to rt7 patch. Can you confirm?
> >
> > If so, which recent kernel should I use in order to get smp and rt
> > running without problems?
> >
> This simple patch should solve the above problem. Seeing the config, its
> seems to be a 32bit box.
>
>
> It convert tlbstate_lock spin_lock to raw_spin_lock.
> Preemption has already been disabled, hence this change shouldn't
> affect latency numbers.
>
>
> Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>
>
>
> diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
> index 9bb2363..228849c 100644
> --- a/arch/x86/kernel/tlb_32.c
> +++ b/arch/x86/kernel/tlb_32.c
> @@ -23,7 +23,7 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
>  static cpumask_t flush_cpumask;
>  static struct mm_struct *flush_mm;
>  static unsigned long flush_va;
> -static DEFINE_SPINLOCK(tlbstate_lock);
> +static DEFINE_RAW_SPINLOCK(tlbstate_lock);
>
>  /*
>  * We cannot call mmdrop() because we are in interrupt context,
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
--linux(2.4/2.6),bsd(4.5.x+),solaris(2.5+)
