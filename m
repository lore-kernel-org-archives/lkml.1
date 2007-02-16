Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbXBPHHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbXBPHHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXBPHHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:07:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958AbXBPHHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:07:14 -0500
Date: Thu, 15 Feb 2007 23:06:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
Message-Id: <20070215230611.d89e26be.akpm@linux-foundation.org>
In-Reply-To: <45D54BD5.8010707@vmware.com>
References: <20070216022449.739760547@goop.org>
	<20070216022531.570154735@goop.org>
	<45D54BD5.8010707@vmware.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 22:14:45 -0800 Dan Hecht <dhecht@vmware.com> wrote:

> >  config PREEMPT
> >  	bool "Preemptible Kernel (Low-Latency Desktop)"
> > +	depends on !XEN
> >  	help
> >  	  This option reduces the latency of the kernel by making
> >  	  all kernel code (that is not executing in a critical section)
> > 

Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  In which case
that preempt_disable() I spotted is wrong-and-unneeded.

Why doesn't Xen work with preemption??

> I hate to sound like a broken record, but this really isn't the right 
> way to do this.  If you are going to inhibit config settings when Xen 
> support is compiled, then it should be:
> 
> config XEN
>      depends on !KEXEC && !DOUBLEFAULT && HZ_100 && !PREEMPT
> 

Agree.
