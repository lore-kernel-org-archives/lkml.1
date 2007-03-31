Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXCaUtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXCaUtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXCaUtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:49:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXCaUtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:49:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix microcode-related suspend problem
Date: Sat, 31 Mar 2007 22:52:29 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Pavel Machek <pavel@ucw.cz>, Maxim <maximlevitsky@gmail.com>
References: <200703312204.15752.rjw@sisk.pl> <20070331133532.0d791f6e.akpm@linux-foundation.org>
In-Reply-To: <20070331133532.0d791f6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703312252.29873.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 31 March 2007 22:35, Andrew Morton wrote:
> On Sat, 31 Mar 2007 22:04:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This patch appeard on LMKL six days ago and there have not been any negative
> > comments since then, so I think I can try to make it official.
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Fix the regression resulting from the recent change of suspend code ordering
> > that causes systems based on Intel x86 CPUs using the microcode driver to
> > hang during the resume.
> > 
> > The problem occurs since the microcode driver uses request_firmware() in its
> > CPU hotplug notifier, which is called after tasks has been frozen and hangs.
> > It can be fixed by telling the microcode driver to use the microcode stored in
> > memory during the resume instead of trying to load it from disk.
> 
> CONFIG_SMP=n:

Ah, sorry.  I tend to forget about it ...

> arch/i386/kernel/microcode.c: In function 'microcode_init_cpu':
> arch/i386/kernel/microcode.c:628: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> arch/i386/kernel/microcode.c:628: error: (Each undeclared identifier is reported only once
> arch/i386/kernel/microcode.c:628: error: for each function it appears in.)
> arch/i386/kernel/microcode.c: In function 'mc_sysdev_add':
> arch/i386/kernel/microcode.c:717: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> arch/i386/kernel/microcode.c: In function 'mc_sysdev_remove':
> arch/i386/kernel/microcode.c:745: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> 
> Given this, and the overall intrusiveness of the change, I'd worry about
> trying to get this into 2.6.21.

Well, in that case I'll try to fix it later in a slightly different way.
