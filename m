Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZAaBqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZAaBqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZAaBqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:46:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbZAaBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:46:08 -0500
Date: Fri, 30 Jan 2009 17:46:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Parag Warudkar <parag.lkml@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <alpine.DEB.2.00.0901302016170.5643@parag-desktop>
Message-ID: <alpine.LFD.2.00.0901301741380.3150@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901310059.17746.rjw@sisk.pl> <alpine.DEB.2.00.0901301924550.5056@parag-desktop> <200901310138.51214.rjw@sisk.pl> <alpine.DEB.2.00.0901302016170.5643@parag-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Parag Warudkar wrote:
> 
> Excellent! This patch works - tg3 comes back and gets link after resume.

I still think the patch isn't very good. See my previous email. 

The fact that your machine works again is good, though. But before we let 
this lie, I'd _really_ like to know what was broken in the legacy PM path, 
rather than "let's leave it behind". Because a broken legacy path will end 
up biting us for other drivers, and I think the new PM path will need more 
work before it's ready for prime-time.

> Are the below differences worth worrying about - especially since post 
> suspend some DevID/VendorID and some capabilities seem to be changed?

That's not a devid/vendorid, it's an extended "subsystem" capability that 
we didn't save. We could try to save/restore all capabilities, but right 
now we only do the ones we care about (pcie/pcix/msi, iirc).

I do suspect we might be better off saving everything we can, rather than 
deciding piece-meal to save specific capabilities we know about.

			Linus
