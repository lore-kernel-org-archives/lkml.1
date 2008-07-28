Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYG1RrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYG1RrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYG1Rqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:46:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYG1Rqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:46:54 -0400
Date: Mon, 28 Jul 2008 19:46:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
Message-ID: <20080728174644.GC30344@one.firstfloor.org>
References: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * Fall back to the default idle loop, when pm_idle_save had
> +	 * been initialized.
> +	 */
> +	if (pm_idle_save) {
> +		pm_idle = pm_idle_save;
> +		/* Relies on interrupts forcing exit from idle. */
> +		synchronize_sched();
> +	}

I think it would be better to fall  back to default_idle (which
might need to be exported) when the old pointer is NULL. Now with your patch 
the cpuidle idle code would run with inconsistent state for some time,
which is probably not good.

-Andi
