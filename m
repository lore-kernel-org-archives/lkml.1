Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYBYU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYBYU0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYBYU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:26:43 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222AbYBYU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:26:42 -0500
Date: Mon, 25 Feb 2008 12:14:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
Message-Id: <20080225121440.32810c91.akpm@linux-foundation.org>
In-Reply-To: <47C0BAD9.7030908@googlemail.com>
References: <47C0BAD9.7030908@googlemail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 01:31:21 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:

> Hi,
> 
> I noticed tsc is always marked unstable on my box with 2.6.25* , 2.6.24 is fine.
> 
> ...
> 
> [    0.825760] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    0.805755] Switched to high resolution mode on CPU 1
> [    0.794244] Switched to high resolution mode on CPU 2
> [    0.766968] Switched to high resolution mode on CPU 3
> [    1.083944] Switched to high resolution mode on CPU 0
> [   15.388792] Clocksource tsc unstable (delta = 9373391604 ns)
> [   15.714648] Time: acpi_pm clocksource has been installed.
> 
> ...
> 
> Booting nohz=off fixes that.
> 
> Another strange thing is when I try to boot that kernel with clocksource=acpi_pm it just hangs.
> 
> config is attached.
> 
> Please let me know if you need more infos / want me to try patches or anything else.
> 
> 

I suppose we should consider this a regression.  If only because acpi_pm is
slower.  But mainly because (afaik) this change was not intentional.
