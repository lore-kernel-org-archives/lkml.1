Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXKOV52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXKOV52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765782AbXKOV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:57:15 -0500
Received: from gw.goop.org ([64.81.55.164]:50203 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765618AbXKOV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:57:14 -0500
Message-ID: <473CC0AC.3020500@goop.org>
Date: Thu, 15 Nov 2007 13:57:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Why preallocate pmd in x86 32-bit PAE?
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at unifying asm-x86/pgalloc*.h, and so I'm trying to make
things as similar as possible between 32 and 64-bit.

Once difference is that 64-bit incrementally allocates all levels of the
pagetable, whereas 32-bit PAE preallocates the 4 pmds when it allocates
the pgd.  What's the rationale for this?  What pitfalls would there be
in making them incrementally allocated?

Preallocation makes sense from the perspective that they will all be
allocated almost immediately in a typical process.  But it is a somewhat
arbitrary difference from 64-bit, and since 64-bit can't reasonably
preallocate any pagetable levels, it seems sensible to change 32-bit to
match.

Thanks,
    J
