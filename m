Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYLEWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYLEWO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYLEWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:14:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbYLEWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:14:47 -0500
Date: Fri, 5 Dec 2008 14:14:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812052301.45450.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812051411400.3386@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org> <200812052301.45450.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> 
> Well, actually I think we should go further and save the standard config
> registers of _all_ PCI devices in the _late() callbacks (ie. with interrupts
> disabled) and restore them in the _early() callbacks.

That would certainly simplify the code. 

> I don't really understand why pci_restore_state() is not called by the core
> and every single driver calls it by itself.

The idea was to allow PCI drivers to override it if they wanted to.

That said, the ones that do their own state restore generally do it wrong 
(eg the USB host controllers doing things in the wrong order and enabling 
the device before having actually written back the BAR values), so it's 
arguably broken to let drivers override it.

> IOW, I would split the resume of PCI devices into two parts, the first of
> which will call pci_restore_state() with interrupts disabled and the second
> will do the remaining stuff.

I would definitely not disagree with that - leave the regular 
"suspend/resume" callbacks for purely higher-level actions. It would 
interesting to hear what it does for you.

			Linus
