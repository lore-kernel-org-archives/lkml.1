Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0BXGvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 01:51:13 -0500
Received: from compulab.co.il ([67.18.134.219]:46831 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0BXGvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 01:51:12 -0500
Message-ID: <4B84CC0E.5060203@compulab.co.il>
Date: Wed, 24 Feb 2010 08:49:50 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Denis Turischev <denis@compulab.co.il>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
References: <4B73DAEE.5080400@compulab.co.il> <4B7C0DC3.3060907@compulab.co.il> <4B812C21.8000602@compulab.co.il> <201002211112.48527.david-b@pacbell.net>
In-Reply-To: <201002211112.48527.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Sunday 21 February 2010, Denis Turischev wrote:
>> v2: there is no acpi_check_region, it will be implemented in mfd-core
>> v3: patch refreshed against the latest Linus tree
> 
> Could such call really address the GPIO conflict issue I mentioned?
> 
> The AML bytecodes I looked at were writing directly to Southbridge
> GPIO registers (or reading them), or relying on ACPI to mediate the
> GPIO interrupts.  ISTR that button drivers, and code to switch into
> or out of low power states, were good sources of such bad examples.

I'm really not an ACPI expert, but as far as I understand possibility of 
such conflicts largely depends on particular board/BIOS implementation. 
On the hardware we have such conflict cannot happen, unless there are 
bugs in ACPI we are not yet aware of. :)

> Calls like that should clearly be able to handle cases where ACPI
> has a "Real" Driver (tm) ... e.g. for SMBus hardware.
> 
> I'm not sure what a good solution for this would be, short of just
> not using ACPI ... which may not be practical, given the limited
> degree of x86 board/system support for Linux.
> 
> I mention this mostly because when I looked at the issue in the
> context of an ICHx GPIO driver, I didn't see a good solution to
> the problem then ... and nothing seems to have changed meanwhile.

I've looked at two x86 drivers in drivers/gpiolib (cs5535 and langwell) 
and there's no treatment of ACPI in either of them. Since SCH is defined 
by Intel as "embedded" product, having a GPIO driver for it seems 
logical even despite problems you mention.

> - Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Sincerely yours,
Mike.

