Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYLFCTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYLFCTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYLFCSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:18:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYLFCSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:18:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Sat, 6 Dec 2008 03:18:07 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812060218.13030.rjw@sisk.pl> <alpine.LFD.2.00.0812051750450.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812051750450.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812060318.08532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> >
> > It only affects the legacy handling, but the non-legacy handling was left
> > untouched.  IOW, the old "default" functions are still there and are being
> > called by the "non-legacy" code (it's only used by USB at the moment, AFAICS).
> 
> Ok.
> 
> > Anyway, I did the test doing it only to the devices which don't have any
> > non-default suspend-resume handling at all and _that_ apparently fixed the
> > problem on my box. :-)
> 
> Which makes sense, btw. Because if you do the pci_save_state() on a device 
> that _does_ have a suspend function, you'll be saving the post-suspend 
> state - ie the device turned off.
> 
> So yeah, we really can only do the default suspend if the device has no 
> pre-existing suspend function - or we'd need to make sure that all PCI 
> drivers that do have suspend functions would only do the higher-level 
> functionality.
> 
> Anyway, what I'm most interested in hearing is whether this actually 
> improves your situation.

Yes, it does, from what I can tell at the moment. :-)

Tomorrow I'll do more testing to (hopefully) confirm that.

> I can _easily_ see that your resume problem could be due to interrupt
> timing. That's especially true if there are shared interrupts, but even in
> the absense of that, I'm not at all sure that the e1000e resume code is
> interrupt-safe, for example. 

Agreed.

Thanks,
Rafael
