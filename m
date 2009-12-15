Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZLOCbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZLOCbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZLOCbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:31:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbZLOCbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:31:50 -0500
Date: Mon, 14 Dec 2009 18:29:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>, Russ Dill <Russ.Dill@gmail.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912141744360.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912141827200.14385@localhost.localdomain>
References: <20091211212646.GB6624@kroah.com> <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain> <20091215005216.GA9309@kroah.com> <alpine.LFD.2.00.0912141658290.14385@localhost.localdomain>
 <alpine.LFD.2.00.0912141744360.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Linus Torvalds wrote:
> 
> Not surprising, and there's 85 commits in between those points, so I'll 
> have to do 7 more bisection points.

It bisected down to this:

commit a2582bd478c13c574d4c16ef1209d333f2a25935
Author: Russ Dill <russ.dill@gmail.com>
Date:   Wed Nov 18 11:02:13 2009 -0700

    USB: Close usb_find_interface race
    
    USB drivers that create character devices call usb_register_dev in their
    probe function. This associates the usb_interface device with that minor
    number and creates the character device and announces it to the world.
    However, the driver's probe function is called before the new
    usb_interface is added to the driver's klist_devices.
    ...

and what's even scarier is that that commit is marked for stable too. Did 
it already make it?

I'll double-check by reverting it from current -tip, but if you don't hear 
anything different from me, you can assume that that double-check 
succeeded and confirms that that commit really is the cause of my printer 
no longer working.

			Linus
