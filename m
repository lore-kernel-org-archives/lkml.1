Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXLWTdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXLWTdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 14:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXLWTc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 14:32:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbXLWTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 14:32:56 -0500
Date: Sun, 23 Dec 2007 11:29:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce
 4 suspend-to-RAM
In-Reply-To: <20071223191937.GA28836@elte.hu>
Message-ID: <alpine.LFD.0.9999.0712231124160.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org> <20071223191937.GA28836@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Ingo Molnar wrote:
> 
> This script will probe all unused ports as per /proc/ioports and will 
> list "suspect" IO port areas: ones that do not produce the expected 0xff 
> default reply from unclaimed IO ports. Magic chipset register areas can 
> potentially be mapped this way.

This probably won't work, if the APCI ports aren't reserved.

The way suspend-to-ram works is that there's a magic port that the CPU 
reads from, which just basically turns the CPU off. 

Same goes for C-states, and while we should recover from that gracefully 
(ie the CPU comes back at wakeup events), if you don't do the right setup, 
that can also just hang the machine..

So this script sounds rather dangerous for this case (while it probably 
tends to work fine for the case of the ACPI ports being properly reserved: 
*most* IO devices tend to try to avoid having too many side effects on 
normal reads - the most common one tends to be to reset any pending 
interrupts from a device, but that one won't matter if we don't have a 
driver listening to that device).

			Linus
