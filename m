Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbXGIELc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbXGIELc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXGIELX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:11:23 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:49049 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXGIELX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:11:23 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 00:11:21 -0400
In-Reply-To: <200707081737.21932.a1426z@gawab.com> (Al Boldi's message of
	"Sun\, 8 Jul 2007 17\:37\:21 +0300")
Message-ID: <87tzsew712.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:

> Pavel Machek wrote:
>> We are stuck with refrigerator for now, and at least for hibernation,
>> I don't see any feasible alternative.

> Feasible alternative?

I posted such an alternative to the list a short time ago: hibenrating
from a *new* kernel space/user space that is created by loading a new
kernel in a manner similar to what is done for kexec crashdumps.  Unlike
kexec crashdumps, however, it would not require reserving any memory at
boot, because the necessary memory (maybe 16MB or 64MB) can be freed
just before hibernating, and device drivers can be properly stopped so
that DMAs don't stomp over certain memory.

This approach eliminates the need for the freezer, as it would make
hibernate look a lot a bit like suspend to ram from the perspective of
the "old" kernel (the kernel being hibernated), as the hibernate
operation itself would be completely atomic from the perspective of the
"old" kernel.  That is not to say, of course, that any code paths would
actually be shared, or that the drivers would do the same things
(because they probably would not).

[snip]

-- 
Jeremy Maitin-Shepard
