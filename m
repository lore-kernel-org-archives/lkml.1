Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXGJRq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXGJRq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbXGJRqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:46:21 -0400
Received: from [212.12.190.203] ([212.12.190.203]:34438 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757449AbXGJRqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:46:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation Redesign
Date: Tue, 10 Jul 2007 20:45:17 +0300
User-Agent: KMail/1.5
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <87hcoduh4k.fsf@jbms.ath.cx> <46939E5E.6010305@goop.org>
In-Reply-To: <46939E5E.6010305@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200707102045.17101.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeremy Maitin-Shepard wrote:
> > I don't know a whole lot about xen, but it seems that one issue with
> > this approach is that it requires you run your system under a hypervisor
> > at all times, which may introduce some overhead.
>
> No, I don't think that's what Al is proposing.  The kernel-internal
> interfaces we've put in place to make Xen work could be reused to do
> some of the things you're talking about.  In particular, a kernel
> running under Xen has to be able to deal with non-contiguous physical
> pages, and reusing the same pagetable hooks would allow a kexeced kernel
> to run happily out of any random assortment of pages you manage to
> allocate for it.

Exactly, there may well be overlap between Xen and the kexec hibernate 
approach, for which code structures should definitely be leveraged.

And, I wasn't suggesting to use Xen as an HV, which wouldn't really solve 
anything, but was trying to point out that there is no need to maintain two 
separate kernels, much like Xen, which inlines two modes into the kernel:  
host and guest.

So kexec really seems the way to go, which mimics the way APM used to do it, 
which is known to work flawlessly with minimal OS involvement.


Thanks!

--
Al
