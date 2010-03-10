Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0CJKzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:55:50 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:3851 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab0CJKzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:55:46 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <m1iq9fvh40.fsf@fess.ebiederm.org>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	 <4B881097.1050505@kernel.org>
	 <1267442545.11737.20718.camel@zakaz.uk.xensource.com>
	 <m1d3zn7uwl.fsf@fess.ebiederm.org>
	 <1267479860.2785.843.camel@localhost.localdomain>
	 <m1iq9fvh40.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 10:55:24 +0000
Message-ID: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add
 arch_probe_nr_irqs() again
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=xE1qpWtd3IAA:10 a=IkcTkHD0fZMA:10 a=SEF7xSSsAAAA:8 a=FPzxDkUJ6XviQSuB8vAA:9 a=TJA9zMuJW9Fo3rLJ-IAWz4FfW_wA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 13:58 -0800, Eric W. Biederman wrote:
> 
> >> - Xen has an array irq_info[NR_IRQS] one of the last static arrays
> >>   sized at NR_IRQs in the entire kernel.
> >
> > Hopefully the same info as is in that array could (and indeed
> should) be
> > instead stored in irq_desc->chip_data. Would you object to
> > arch_init_copy_chip_data and arch_free_chip_data becoming function
> > pointers within the struct irq_chip?
> 
> No objections.  Now that I see those methods it looks like they always
> should have been in irq_chip. 

The following changes since commit c0a2d57e753717cc893b4b38bfb351c7f19469c3:
  Ingo Molnar (1):
        Merge branch 'perf/urgent'

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-x86/irq

Ian Campbell (3):
      x86: namespace some I/O APIC related structures and functions.
      irq: move some interrupt arch_* functions into struct irq_chip.
      x86: irq_desc->chip_data is always correct whether or not SPARSE_IRQ is enabled.

 arch/powerpc/kernel/irq.c      |    2 +-
 arch/x86/include/asm/hw_irq.h  |   25 +++--
 arch/x86/kernel/apic/io_apic.c |  233 ++++++++++++++++++++++++---------------
 arch/x86/kernel/uv_irq.c       |   19 ++--
 include/linux/interrupt.h      |    2 +-
 include/linux/irq.h            |   12 ++-
 kernel/irq/handle.c            |    2 +-
 kernel/irq/numa_migrate.c      |   12 ++-
 kernel/softirq.c               |    3 +-
 9 files changed, 195 insertions(+), 115 deletions(-)


-- 
Ian Campbell
Current Noise: Mistress - Lord Worm

Nothing is easier than to denounce the evildoer; nothing is more difficult
than to understand him.
		-- Fyodor Dostoevski

