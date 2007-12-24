Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXLXA56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXLXA56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXLXA5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:57:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbXLXA5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:57:48 -0500
Date: Sun, 23 Dec 2007 16:56:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: "H. Peter Anvin" <hpa@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-Reply-To: <200712240009.41764.carlos@strangeworlds.co.uk>
Message-ID: <alpine.LFD.0.9999.0712231621340.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712232320.21182.rjw@sisk.pl> <476EEB6F.7080909@kernel.org> <200712240009.41764.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Dec 2007, Carlos Corbacho wrote:
> 
> Please disregard the patch anyway - my test system was still using the custom 
> DSDT - it doesn't fix anything.

Ok, so it's not a simple IO port conflict.

And the range 0x1400-0x147f (which is apparently the ACPI block) is 
properly marked as reserved.

So the IO write to 1428 is a red herring. It's just part of the normal 
sequence to suspend-to-ram, and while it failing probably has something to 
do with the failure to s2ram, it's simply a result of ACPI doing something 
insane, and probably making some assumptions that we've broken by mistake 
when we do the higher-level device_suspend() before we do the low-level 
one.

IOW, it looks like the normal kind of ACPI mess. Color me not in the least 
surprised, and it needs somebody who understands AML and what the heck is 
supposed to happen to figure out.

The kernel doesn't do anything at all to port 1428 (since it is reserved), 
so if any write to it "fails" (how?) it's probably because the writer made 
some assumptions about system state.

			Linus


