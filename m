Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYGJXMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYGJXMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYGJXL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:11:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40609 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYGJXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:11:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182237.489115000@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 16:08:03 -0700
In-Reply-To: <20080710182237.489115000@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 11:16:45 -0700")
Message-ID: <m13amhgwx8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0285]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 11/26] x64, x2apic/intr-remap: generic irq migration support from process context
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> Generic infrastructure for migrating the irq from the process context in the
> presence of CONFIG_GENERIC_PENDING_IRQ.
>
> This will be used later for migrating irq in the presence of
> interrupt-remapping.

Why the API difference between IRQ_MOVE_PCNTXT set affinity handlers and
!CONFIG_GENERIC_PENDING_IRQ handlers?


>  #ifdef CONFIG_GENERIC_PENDING_IRQ
> -	set_pending_irq(irq, cpumask);
> +	if (desc->status & IRQ_MOVE_PCNTXT) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&desc->lock, flags);
> +		desc->chip->set_affinity(irq, cpumask);
> +		spin_unlock_irqrestore(&desc->lock, flags);
> +	} else
> +		set_pending_irq(irq, cpumask);
>  #else
>  	desc->affinity = cpumask;
>  	desc->chip->set_affinity(irq, cpumask);
>
> -- 
