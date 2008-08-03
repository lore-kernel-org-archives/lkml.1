Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYHCFNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYHCFNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYHCFNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:13:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55553 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYHCFNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:13:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
Date: Sat, 02 Aug 2008 22:09:26 -0700
In-Reply-To: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Fri, 1 Aug 2008 19:02:55 -0700")
Message-ID: <m1myjuadmh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0512]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: 64bit support more than 256 irq v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> Dhaval Giani got:
> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
> invalid opcode: 0000 [1] SMP
> CPU 24
> ...
>
> his system (x3950) has 8 ioapic, irq > 256
>
> caused by
>         commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>         Author: Thomas Gleixner <tglx@linutronix.de>
>         Date:   Fri May 2 20:10:09 2008 +0200
>
>            x86: unify interrupt vector defines
>
>            The interrupt vector defines are copied 4 times around with minimal
>            differences. Move them all into asm-x86/irq_vectors.h
>
> because 64bit allow same vector for different cpu to serve different irq
>
> need to create that array dynamically later

YH Thank you for splitting this out.  This still doesn't restore the
pre merge NR_IRQS heuristic.  So I don't think it is a proper regression fix.

Eric
