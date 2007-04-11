Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbXDKHR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbXDKHR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXDKHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:17:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXDKHRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:17:25 -0400
Date: Wed, 11 Apr 2007 00:17:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
Message-Id: <20070411001717.02ae5640.akpm@linux-foundation.org>
In-Reply-To: <461C81C0.9040003@yahoo.com.au>
References: <7.469046093@selenic.com>
	<461C81C0.9040003@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 16:35:44 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Matt Mackall wrote:
> > Move the page walker code to lib/
> > 
> > This lets it get shared outside of proc/ and linked in only when
> > needed.
> 
> Still should go into mm/

spose so.

> If it had, you might have also noticed your pagetable walking code
> is completely different from how everyone else does it, and fixed
> that too.

Different in what way?

> BTW. Is it the case that unused and unexported symbols don't get
> pruned by the linker except inside lib/?

If they're static and unreferenced then the linker will remove them.  Of
course, usually humans remove these because they generate warnings, unless
special-things happen.  We deliberately do special-things with
register_cpu_notifier() so the notifier-block and the handler go away if
!CONFIG_HOTPLUG_CPU.

If the functions are non-static then yes, I expect we end up with them in
vmlinux.  There are tricks we can play with -ffunction-sections to fix
that, but we don't.  
