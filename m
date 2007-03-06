Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXCFDKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXCFDKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933887AbXCFDKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:10:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933885AbXCFDKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:10:30 -0500
Date: Mon, 5 Mar 2007 19:10:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH]: i386: make x86_64 tsc header require i386 rather than
 vice-versa
Message-Id: <20070305191021.eb152377.akpm@linux-foundation.org>
In-Reply-To: <45E8E729.2040906@debian.org>
References: <45E8E729.2040906@debian.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 22:10:33 -0500 Andres Salomon <dilinger@debian.org> wrote:

> Prior to commit 95492e4646e5de8b43d9a7908d6177fb737b61f0  ([PATCH] x86:
> rewrite SMP TSC sync code), the headers in asm-i386 did not really
> require anything in include/asm-x86_64.  This means that distributions
> such as fedora did not include asm-x86_64 in kernel-devel headers for
> i386.  Ingo's commit changed that, and broke things.  This is easy
> enough to hack around in package builds by just including asm-x86_64 on
> i386, but that's kind of annoying.  If anything, x86_64 should depend
> upon i386, not the other way around.
> 
> This patch changes it so that asm-x86_64/tsc.h includes asm-i386/tsc.h,
> rather than vice-versa.

Agree - I don't see any gain in making the references be bidirectional, and
it just makes life more complicated.  Knowing "x86_64 always references
i386" is a useful mental mark.

That, plus the kernel-headers point which you describe..

<looks at early_printk.c>
