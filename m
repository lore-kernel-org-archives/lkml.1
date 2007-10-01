Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbXJAKLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbXJAKLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJAKLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:11:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:50470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXJAKLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:11:40 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/2] ACPI: disable lower idle C-states across suspend/resume
References: <20070922220347.586903979@linutronix.de>
	<20070922222118.882356049@linutronix.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 12:11:37 +0200
In-Reply-To: <20070922222118.882356049@linutronix.de>
Message-ID: <p73ir5r6t5y.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>  
> +/*
> + * Suspend / resume control
> + */
> +static int acpi_idle_suspend;
> +
> +int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
> +{
> +	acpi_idle_suspend = 1;
> +	return 0;
> +}
> +
> +int acpi_processor_resume(struct acpi_device * device)
> +{
> +	acpi_idle_suspend = 0;
> +	return 0;
> +}

Instead of the ugly global variable you could you could just change 
pm_idle back to NULL (= default_idle) and then later restore it.

-Andi
