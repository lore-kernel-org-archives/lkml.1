Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103Ab0AHUnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0AHUnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670Ab0AHUnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:43:49 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48029 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0AHUnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pZJR5cy6CyT5lFbu7z5Ka0g3skob8PDp5OjMgL1DY9jWMOjjknn/xD5AaAkgf/052w
         67b0jGJ4gO/yzEGDb1a6+qZbs3/klOcJfuyPiGLW0GheADCZqX9BqPjM4yiToHS3L2SC
         CMCS2Czg9sLfWAK9XeNNTrIzBRR0Nh1u8b5fQ=
MIME-Version: 1.0
In-Reply-To: <m1tyuwgxgb.fsf@fess.ebiederm.org>
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	 <1262951595-1729-5-git-send-email-yinghai@kernel.org>
	 <m1bph4o1il.fsf@fess.ebiederm.org>
	 <86802c441001081149k1be26027m62752604dca53aa@mail.gmail.com>
	 <m1tyuwgxgb.fsf@fess.ebiederm.org>
Date: Fri, 8 Jan 2010 12:43:48 -0800
X-Google-Sender-Auth: b183b905759400c6
Message-ID: <86802c441001081243w246b581elfbf09fdaf18883b0@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 12:20 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Based on my quick look the bad offenders (aka static sized arrays of
> NR_IRQS) all look at NR_IRQS not nr_irqs.  So I don't see a point
> in having nr_irqs < NR_IRQS.
>
> So let's just kill arch_probe_nr_irqs() on x86.
>
> Then we can worry about things like fixing xen and the interrupt
> remapping code to not having NR_IRQS sized arrays.

arch/sh/kernel/irq.c:int __init arch_probe_nr_irqs(void)
arch/x86/kernel/apic/io_apic.c:int __init arch_probe_nr_irqs(void)
arch/x86/kernel/apic/io_apic.c:  *  if we move calling of
arch_probe_nr_irqs() after init_IRQ()
include/linux/interrupt.h:extern int arch_probe_nr_irqs(void);
kernel/irq/handle.c:    arch_probe_nr_irqs();
kernel/softirq.c:int __init __weak arch_probe_nr_irqs(void)

sh have sparse_irq now...it has it's own copy for arch_probe_nr_irqs...

YH
