Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYLEMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYLEMBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYLEMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:01:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYLEMBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:01:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 13:00:16 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200812051300.16649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > 
> > Ok, the ICH6 LPC side has something similar, but not the same. Just two 
> > ranges, and slightly less flexible wrt sizing.
> > 
> > And ICH8/9/10 seems to have the same thing as ICH7.
> 
> Here's a patch that implements what I think is the correct quirks (apart 
> from the commented ICH6 lazy detail I didn't do).
> 
> It would be very interesting to see if people affected get any printouts 
> about IO decodes that don't show up in /proc/ioports...

>From my box:

pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH6 ACPI/GP IO/TCO
pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)

The second one shows up in /proc/ioports as "01e0-01ef : pnp 00:09", but the
first one (at 680) doesn't.

Thanks,
Rafael
