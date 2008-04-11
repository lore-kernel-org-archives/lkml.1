Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYDKHDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYDKHDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYDKHDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:03:30 -0400
Received: from www.tglx.de ([62.245.132.106]:43465 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbYDKHD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:03:29 -0400
Date: Fri, 11 Apr 2008 09:01:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on
 free_irq
In-Reply-To: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Yinghai Lu wrote:
> last week found:
> after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
> forcedeth doesn't work anymore.
> 
> I stared at forcedeth.c two days. and revert every patches about that
> doesn't help.

So forcedeth does not come up again, when you kexec from linus.git
into an older distro kernel. Or is it the other way round ?

Does a non kexec boot work ?

> and figure out 2.6.25-rc2 works.
> 
> with git-bisect found
> 
> commit 89d694b9dbe769ca1004e01db0ca43964806a611
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Feb 18 18:25:17 2008 +0100
> 
>     genirq: do not leave interupts enabled on free_irq
> 
> caused the regression.
> 
> it affected all my servers that are using Nvidia MCP55.
> 
> maybe we need to revert that patch.

Which causes an interrupt storm on the enabled irq line, when the
interrupt line is still active for whatever reason. So we trade one
badness vs. the other.

Reverting the patch is not going to give us any answer about the real
problem.

Is there anything in dmesg, which might give us an hint about that ?

Thanks,
	tglx
