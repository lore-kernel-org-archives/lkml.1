Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZBBW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZBBW2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZBBW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:28:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZBBW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:28:29 -0500
Date: Mon, 2 Feb 2009 14:26:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] rtc: add rtc_systohc for ntp use
Message-Id: <20090202142613.2ca84f52.akpm@linux-foundation.org>
In-Reply-To: <1233018262.14510.111.camel@localhost.localdomain>
References: <1233018262.14510.111.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 17:04:22 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> Following up to Alessandro's RFC of 10 Nov 2008, this patch implements
> rtc_systohc() to update the configured rtc device (cmos, i2c, etc.) from
> the ntp-synchronized system clock.  It changes the ntp update code to
> call rtc_systohc() rather than update_persistent_clock() which (at least
> on x86) always updates the cmos rtc.
> 
> No attempt is made to compensate for the 500-ms delay imposed when
> setting a cmos rtc chip.  If you actually have a cmos rtc you can stick
> with the existing code, but at some point it would be nice to unify
> these.

I don't get this.  Do we not currently update the cmos clock in
response to NTP controls?  Does the patch now alter this policy, by now
updating the RTC?

IOW: what effect does this patch actually have upon the kernel?


Please cc Roman on NTP changes.  Roman, please consider sending in a
MAINTAINERS patch for this.


Please use scripts/checkpatch.pl.

Please fix the checkpatch warnings which this patch emits.

When fixing the extern-declaration-in-C warning, please consider
dropping the ifdefs around the rtc_systohc() declaration in the header
file.  They're not really needed.

