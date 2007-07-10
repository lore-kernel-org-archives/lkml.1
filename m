Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXGJSV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXGJSV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXGJSVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:21:20 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:51237 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbXGJSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:21:19 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87hcoduh4k.fsf@jbms.ath.cx>
	<46939E5E.6010305@goop.org> <200707102045.17101.a1426z@gawab.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 10 Jul 2007 14:20:40 -0400
In-Reply-To: <200707102045.17101.a1426z@gawab.com> (Al Boldi's message of
	"Tue\, 10 Jul 2007 20\:45\:17 +0300")
Message-ID: <87hcocaznr.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:

[snip]

> Exactly, there may well be overlap between Xen and the kexec hibernate 
> approach, for which code structures should definitely be leveraged.

> And, I wasn't suggesting to use Xen as an HV, which wouldn't really solve 
> anything, but was trying to point out that there is no need to maintain two 
> separate kernels, much like Xen, which inlines two modes into the kernel:  
> host and guest.

With relocatable kernels, or by simply using the "backup the first 16 or
64 MB of physical memory" approach, the same kernel image could be used
both as the normal kernel as the "save image" kernel.  The actual
behavior of the system would likely depend on kernel command-line
parameters or an initrd, rather than being hard-coded into the kernel
image.  If it is made a requirement that the same kernel be used, then
as is done currently, the text sections need not be touched at all.
There is a significant advantage, however, to using a different kernel:
unneeded drivers can be compiled out, leading to faster load times.

> So kexec really seems the way to go, which mimics the way APM used to do it, 
> which is known to work flawlessly with minimal OS involvement.

Now all that is needed is someone with enough time and interest to
implement it.  :)

-- 
Jeremy Maitin-Shepard
