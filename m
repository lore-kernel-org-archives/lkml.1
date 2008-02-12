Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbYBLQY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbYBLQY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYBLQYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:24:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56039 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYBLQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:24:18 -0500
Message-ID: <47B1C829.8020800@garzik.org>
Date: Tue, 12 Feb 2008 11:24:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: multiple drivers, single device (was Re: Announce: Linux-next (Or
 Andrew's dream  :-)))
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com>
In-Reply-To: <20080212042133.GA4625@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> [1] Hopefully the "multiple drivers for a single device" feature people
> have been asking for for years will be landing soon, of course the
> number of odd places in the kernel that made the assumption that we
> could only have one driver per device is causing lots of fun...


Color me a bit skeptical...  we've always had this capability really: 
for multi-function devices, just register as many subsystems as you 
need.  If your device is a network _and_ SCSI device, you can do that 
with today's APIs.

I just went through a long thread (e1000/e1000e) explaining how much 
pain multiple drivers for the same PCI ID cause on the distro side of 
things...  its a mess.  In each case you must write special case code to 
resolve the ambiguity.  You never know which is the best driver to 
choose, or proper module load order -- which may vary depending on 
machine, not just static information captured from a kernel Makefile.

	Jeff


