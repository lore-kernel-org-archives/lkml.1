Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZENUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZENUVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZENUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:21:01 -0400
Received: from www.tglx.de ([62.245.132.106]:57180 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZENUVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:21:01 -0400
Date: Thu, 14 May 2009 22:19:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
In-Reply-To: <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain> <4A0855A5.8040109@tut.fi> <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Len Brown wrote:

> hang on, that patch will fail for the case where valid
> is (about to be) set to 1 and we'll fail to disable the TSC
> for systems which _do_ have c3.  I'll send an updated patch shortly.

Yep, you are right. I missed the cx->valid update in
apic_processor_power_verify_cX(). So my patch would break the laptops
instead of breaking desktops and servers :)

Moving it to acpi_timer_check_state() is the best we can do and that
saves us ifdeffery as well as acpi_timer_check_state() is already x86
only.

Thanks,

	tglx
