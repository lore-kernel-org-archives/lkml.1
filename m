Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYHBCQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYHBCQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYHBCQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:16:30 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17170 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYHBCQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JGFdmBXJ53Cg9ybSMnxhyDaT0/961HZq1sAaV4GQRjgXPRlHXF5TMQ/69By+8vmz0e
         6LcKCaT5OHYVyloYWRh7+fsdt1qQdH9XIS1slqAnT32EhfuXeORkAOckisg3WrjVgfRZ
         ChCqqcI8WLW0LfHpsPWc1KdWGKHFfcSvftsUg=
Message-ID: <86802c440808011916q1a279ael995eaeaa655c239@mail.gmail.com>
Date: Fri, 1 Aug 2008 19:16:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: 64bit support more than 256 irq v2
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 7:02 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> Dhaval Giani got:
> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
> invalid opcode: 0000 [1] SMP
> CPU 24
> ...
>
> his system (x3950) has 8 ioapic, irq > 256
>
> caused by
>        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>        Author: Thomas Gleixner <tglx@linutronix.de>
>        Date:   Fri May 2 20:10:09 2008 +0200
>
>           x86: unify interrupt vector defines
>
>           The interrupt vector defines are copied 4 times around with minimal
>           differences. Move them all into asm-x86/irq_vectors.h
>
> because 64bit allow same vector for different cpu to serve different irq
>
> need to create that array dynamically later
>
> v2: change NR_IRQS to 1024
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

this is for
http://bugzilla.kernel.org/show_bug.cgi?id=11201

but need SGI guys to verify in their system. they like to have NR_IRQS to be 224

otherwise we need to use dyn_array solution or wait for Eric come out
dyn irq_desc/irq_cfg

YH
