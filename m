Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXCaUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXCaUg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXCaUg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:36:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35495 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXCaUg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:36:26 -0400
Date: Sat, 31 Mar 2007 13:35:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Pavel Machek <pavel@ucw.cz>, Maxim <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Fix microcode-related suspend problem
Message-Id: <20070331133532.0d791f6e.akpm@linux-foundation.org>
In-Reply-To: <200703312204.15752.rjw@sisk.pl>
References: <200703312204.15752.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 22:04:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This patch appeard on LMKL six days ago and there have not been any negative
> comments since then, so I think I can try to make it official.
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix the regression resulting from the recent change of suspend code ordering
> that causes systems based on Intel x86 CPUs using the microcode driver to
> hang during the resume.
> 
> The problem occurs since the microcode driver uses request_firmware() in its
> CPU hotplug notifier, which is called after tasks has been frozen and hangs.
> It can be fixed by telling the microcode driver to use the microcode stored in
> memory during the resume instead of trying to load it from disk.

CONFIG_SMP=n:

arch/i386/kernel/microcode.c: In function 'microcode_init_cpu':
arch/i386/kernel/microcode.c:628: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
arch/i386/kernel/microcode.c:628: error: (Each undeclared identifier is reported only once
arch/i386/kernel/microcode.c:628: error: for each function it appears in.)
arch/i386/kernel/microcode.c: In function 'mc_sysdev_add':
arch/i386/kernel/microcode.c:717: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
arch/i386/kernel/microcode.c: In function 'mc_sysdev_remove':
arch/i386/kernel/microcode.c:745: error: 'suspend_cpu_hotplug' undeclared (first use in this function)

Given this, and the overall intrusiveness of the change, I'd worry about
trying to get this into 2.6.21.

