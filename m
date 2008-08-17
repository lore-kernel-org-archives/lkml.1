Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYHQVyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYHQVyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 17:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYHQVxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 17:53:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8298 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYHQVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 17:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pL/UGikCRX51Ov/0mm9wfbEpuIgliomSO6cHj3JI758hyTHlSqz2IQ9FD03IXPZH7I
         874CPAyAkoKCjT9LTcMD6tovo1qnudQknw7joc64kaChuAl3Jpvr2r6Zu6o2s3BVu1Ox
         Z1uJ374bdvSvZDwRzefDCxRwhXDhLzV/joQJM=
Message-ID: <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com>
Date: Sun, 17 Aug 2008 14:53:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH 0/9] -tip/apic merging one more series
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check if you need { } otherwise you broke 64 bit


static int lapic_resume(struct sys_device *dev)
{
        unsigned int l, h;
        unsigned long flags;
        int maxlvt;

        if (!apic_pm_state.active)
                return 0;

        maxlvt = lapic_get_maxlvt();

        local_irq_save(flags);

#ifdef CONFIG_X86_64
        if (x2apic)
                enable_x2apic();
        else
#endif
                /*
                 * Make sure the APICBASE points to the right address
                 *
                 * FIXME! This will be wrong if we ever support suspend on
                 * SMP! We'll need to do this as part of the CPU restore!
                 */
                rdmsr(MSR_IA32_APICBASE, l, h);
                l &= ~MSR_IA32_APICBASE_BASE;
                l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
                wrmsr(MSR_IA32_APICBASE, l, h);


YH
