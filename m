Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXBWGxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXBWGxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXBWGxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:53:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34365 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXBWGxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:53:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix the irq migration
References: <20070222172135.A27563@unix-os.sc.intel.com>
Date: Thu, 22 Feb 2007 23:52:50 -0700
In-Reply-To: <20070222172135.A27563@unix-os.sc.intel.com> (Suresh B. Siddha's
	message of "Thu, 22 Feb 2007 17:21:36 -0800")
Message-ID: <m1ps81wekd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> While debugging some other irq migration issue, observed this issue with
> -git kernels. Ingo, please ACK it.
> ---
>
> With the commit 76d2160147f43f982dfe881404cfde9fd0a9da21, irq_chip
> default_disable() became an empty function. And with this change, irq
> migration in the case of Edge triggered IO-APIC and MSI interrupts happens
> with out masking the irq.
>
> Appended patch fixes by using the mask/unmask handlers of irq_chip directly
> while doing the irq migration.

Close.

If the irq is disabled we need to bail out instead of skipping the
masking.

The masking is required for the function to run correctly and
when IRQ_DISABLED is set we don't know enough to do anything.

Once this is fixed we just need to fix the msi case where the
hardware doesn't provide a mask bit.

Eric
