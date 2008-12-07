Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYLGQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYLGQog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYLGQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:44:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbYLGQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:44:27 -0500
Date: Sun, 7 Dec 2008 08:44:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
In-Reply-To: <200812071347.18608.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812070835040.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org> <20081207054149.GA20415@kroah.com> <200812071347.18608.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Dec 2008, Rafael J. Wysocki wrote:
> 
> If there is no objection from Jesse and if you don't mind, I'll prepare a
> version of the $subject patch on top of the patch in your tree and send it to
> you.

Rafael: there's a bug in your 1/3 patch. 

It looks like "pci_save_state()" is currently unhappy with being called 
with interrupts disabled. Or at least "pci_save_pci[ex]_state()" state 
are. They both do a kzalloc(GFP_KERNEL).

So you should change that GFP_KERNEL into a GFP_ATOMIC. Or do something 
more complicated like pre-allocate them during early suspend, but just 
changing it to GFP_ATOMIC seems to be the trivial fix.

I'm not seeing any other issues with saving/restoring things with irq's 
disabled, but people should be on the lookout for details like this.

			Linus
