Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXGKENT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXGKENT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXGKENK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:13:10 -0400
Received: from [212.12.190.99] ([212.12.190.99]:32826 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751598AbXGKENJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:13:09 -0400
From: Al Boldi <a1426z@gawab.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 07:11:26 +0300
User-Agent: KMail/1.5
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <871wfguq5g.fsf@jbms.ath.cx> <46940F45.3090005@goop.org>
In-Reply-To: <46940F45.3090005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707110711.26767.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeremy Maitin-Shepard wrote:
> >   In
> > addition, I recall that the Linux boot procedure on x86 and on some
> > other platforms necessarily uses certain low-address memory, like the
> > first 640K, which must be backed up regardless.
>
> Well, the traditional framebuffer/ISA space between 640k and 1M probably
> needs to be identity mapped, but I don't think there's anything in there
> which specifically needs to be save/restored (except framebuffer
> contents, maybe?).
>
> > For these reasons, it seems that it would be easiest to simply backup
> > the first e.g. 16 or 64 MB of memory, and not have to worry about
> > loading the kernel at a non-standard address and specifying a
> > complicated exact memmap.  Someone might prove me wrong, though.
>
> Yes, I suppose.  You're certain the old kernel's devices are completely
> quiescent at that point?

That's exactly the problem; trying to save a state from within the kernel 
would probably necessitate a freezer hack, which we are trying so dearly to 
avoid.

The only way the kexec approach may be successful, is by completely relying 
on the kexec'd hibernate-mode kernel to save state, otherwise we would be 
back to square one.  And if that required a special boot procedure for the 
kexec'd hibernate-mode kernel, then why not?


Thanks!

--
Al

