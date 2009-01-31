Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZAaC0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZAaC0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZAaC0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:26:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZAaCZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:25:59 -0500
Date: Fri, 30 Jan 2009 18:25:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Parag Warudkar <parag.lkml@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <alpine.DEB.2.00.0901302051390.5643@parag-desktop>
Message-ID: <alpine.LFD.2.00.0901301820080.3150@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901310059.17746.rjw@sisk.pl> <alpine.DEB.2.00.0901301924550.5056@parag-desktop> <200901310138.51214.rjw@sisk.pl> <alpine.DEB.2.00.0901302016170.5643@parag-desktop>
 <alpine.LFD.2.00.0901301741380.3150@localhost.localdomain> <alpine.DEB.2.00.0901302051390.5643@parag-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Parag Warudkar wrote:
> 
> Ok - I will run with it temporarily and will do what I can to track down 
> what was wrong with the legacy PM.

If you can try the patch I just sent out, and use that as a base for 
trying to track down why the heck the legacy code doesn't work, that would 
be great. It might fix it (assuming my guess about "restore_state while in 
PCI_D3 doesn't work" was correct), but quite frankly, it's equally 
possible that it just makes things worse. But it would be really 
interesting to hear..

Your machine does seem to be interesting, in that not only does it have a 
PCI-E bridge in it (the eeepc I was playing around with at LCA does not), 
but judging by the lost config state I also suspect that it actually loses 
power during STR.

Which is not at all necessarily a given - I suspect it depends on just how 
the power rails are set up on the motherboard. The fact that PCI-E bridges 
have apparently worked for others implies that your problems don't happen 
for everybody, and may relate to that issue.

		Linus
