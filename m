Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZFPAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZFPAQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZFPAQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:16:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZFPAQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:16:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Date: Tue, 16 Jun 2009 02:16:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20090615232709.GA6059@sig21.net>
In-Reply-To: <20090615232709.GA6059@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160216.29537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009, Johannes Stezenbach wrote:
> Hi,
> 
> on my aging Thinkpad T42p resume from hibernation
> fails in 2.6.30. There is a backtrace on suspend prior
> to writing out the disk image, but I cannot capture
> it due to lack of a serial port on the T42p. On
> resume the machine is dead after reading the image
> from disk.
> 
> I've bisected this to:
> 
>  commit 01599fca6758d2cd133e78f87426fc851c9ea725
>  Author: Andrew Morton <akpm@linux-foundation.org>
>  Date:   Mon Apr 13 10:27:49 2009 -0700
> 
>     cpufreq: use smp_call_function_[single|many]() in acpi-cpufreq.c
> 
> I see in git log that this commit is known broken, but the
> resume on my machine is still broken in 2.6.30.
> 
> If I disable CONFIG_X86_ACPI_CPUFREQ suspend/resume works in 2.6.30.

Thanks a lot for bisecting this!

Is it the reason for the enabling of interrupts during cpufreq_suspend()?

/me wonders

Is there anything we can do to fix this quickly?

Rafael
