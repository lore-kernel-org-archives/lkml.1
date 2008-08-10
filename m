Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYHJHh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYHJHh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYHJHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYHJHhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P0wxJda9rJCZa48+xW40JoIwEr/XxfuOwatY2m5BkbAEYyB1pPwS+knfxOPRPRWd0G
         qBTcMLUP7K8P7PF0JhVCgJ++OG65F/M9VacAEn1oTy4UF2ZLd5PrFbUerxCIfkwqEqTp
         8XZeWIjy6tc+W1+q5a0iEOgeTinXypBww3DdA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/43] dyn_array/nr_irqs/sparse_irq support v7
Date: Sun, 10 Aug 2008 00:35:49 -0700
Message-Id: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check dyn_array support for x86
v3: split changing to nr_irqs to small patches
   fix checkpatch error
   reorder the patch sequence to make dyn_array support go at first
       so could use that with arrays other than NR_IRQS

v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
   so could use 32 init, and init more if needed.
   x86 32bit: have CONFIG_HAVE_DYN_ARRAY
   x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ

v5: apply alan cox patch with NR_IRQS for serial at first
   seperate irq_descX with irq_descX_free, so could use -1U as valid irq
   expand /proc/interrupts to process > nr_irqs
   hook irq_2_iommu to irq_desc
   more other arch irq_desc[] to irq_desc(), and kstat_cpu().irqs[] to kstat_irqs_cpu..

v6: fixed checkpatch errors.., only left warning about lines > 80 chars.
   put Eric's patch about NR_IRQS at first

v7: according to Eric, need to take care of that some arch doesn't use generic_hardirqs
   reorder some sequence, squash some patches into previous to make patchset bisectable.

based on tip/master

to do:
   so dyn irq_desc is done, and ready to:
   make create_irq to get irq according to bus/dev/func/vector

Thanks

Yinghai Lu

