Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXGHOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXGHOhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXGHOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 10:37:24 -0400
Received: from [212.12.190.146] ([212.12.190.146]:34012 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751257AbXGHOhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 10:37:23 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Hibernation Redesign (was: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM)
Date: Sun, 8 Jul 2007 17:37:21 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081737.21932.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> We are stuck with refrigerator for now, and at least for hibernation,
> I don't see any feasible alternative.

Feasible alternative?

Freezing is the only way to successfully suspend, in kernel space that is.  
The problem here is:  Why do we freeze in kernel space?

APM didn't freeze in kernel space, and neither should ACPI.  The only reason 
you would want to freeze in kernel space is because your system does not 
have APM or ACPI or anything else to freeze from BIOS level.

So the problem is really easy to solve: either call the APM suspend functions 
or install ACPI soft-extensions to implement hibernation from BIOS level.

But there is a catch:  Hibernation from BIOS level probably requires a 
diskdriver, which isn't always available from BIOS level or is really slow.  

So you are back to freezing in kernel space, but this time you know why, and 
that you need a system that simply halts to disk after issuing sync-out 
requests to all peripheral devices involved.  Which sounds like the freezer 
in mainline, does it not?  And if it does, then what's the problem?


Thanks!

--
Al

