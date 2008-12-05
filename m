Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYLEP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYLEP7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbYLEP64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:58:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968AbYLEP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:58:54 -0500
Date: Fri, 5 Dec 2008 07:57:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812051300.16649.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812050754020.3386@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org> <200812051300.16649.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > It would be very interesting to see if people affected get any printouts 
> > about IO decodes that don't show up in /proc/ioports...
> 
> From my box:
> 
> pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH6 ACPI/GP IO/TCO
> pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH6 GPIO
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
> 
> The second one shows up in /proc/ioports as "01e0-01ef : pnp 00:09", but the
> first one (at 680) doesn't.

Ok, so the patch is interesting and probably worth expanding on (to 
actually allocate the regions), but at the same time it too doesn't 
actually explain your problems.

While the kernel doesn't know about that magic 0x680 allocation, it also 
won't be allocating anything over it, since we define PCIBIOS_MIN_IO to 
0x1000 on x86, and will never allocate new resources under that.

		Linus
