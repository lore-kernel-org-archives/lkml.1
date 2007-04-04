Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXDDUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXDDUtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXDDUtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:49:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55943 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXDDUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:49:09 -0400
Date: Wed, 4 Apr 2007 13:48:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@mvista.com>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
 tree
Message-Id: <20070404134812.0c23c5af.akpm@linux-foundation.org>
In-Reply-To: <20070404203647.GA12563@elte.hu>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	<1175417035.28263.42.camel@localhost.localdomain>
	<1175704712.15973.35.camel@imap.mvista.com>
	<20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	<1175717425.15973.61.camel@imap.mvista.com>
	<20070404203647.GA12563@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 22:36:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The struct clocksource .list field is now required to be initialized 
> > before calling clocksource_register().
> > 
> > This is a prerequisite for simplifying the clocksource registration 
> > process.
> 
> why?

It's all enablement for
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/clocksource-refactor-duplicate-registration-checking.patch,
on which I have no opinion.


> This patch only pushes some unnecessary code into the clocksource 
> drivers:
> 
> +       .list           = LIST_HEAD_INIT(clocksource_avr32.list),
> 
> NACK unless you can give an explanation of why this is unavoidable. A 
> NULL initializer is just as good as an initialized list entry. (in fact 
> it's slightly better because it's in the kernel's BSS)
> 

No, these structures are already in .data.

        .mask   = CLOCKSOURCE_MASK(32),
        .mult   = 0,
        .shift  = 20,
+       .list   = LIST_HEAD_INIT(clocksource_pit.list),
 };
