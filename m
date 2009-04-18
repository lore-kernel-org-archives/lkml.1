Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZDRTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZDRTMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZDRTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:12:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZDRTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:12:14 -0400
Date: Sat, 18 Apr 2009 12:06:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
In-Reply-To: <20090418135323.GA7148@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0904181205010.4042@localhost.localdomain>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181523.36010.rjw@sisk.pl> <20090418135323.GA7148@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Russell King wrote:
> 
> What I need to be able to do is to suspend most devices on the host side
> which may involve talking to a separate microcontroller via I2C to shut
> down power to peripherals.

I suspect that for cases like this, the simplest thing to do is to just 
add a marker for "don't mess with my power management, I'm doing 
everything through sysdev" for the specified devices.

Then those i2c controllers (and perhaps some PCI bridges etc) can just set 
that bit, and the device would basically turn invisible as far as the PM 
layer is concerned.

Not that different from the IRQF_TIMER bit for timer interrupts.

			Linus
