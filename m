Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbXEWV5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbXEWV5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXEWV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:57:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756245AbXEWV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:57:15 -0400
Date: Wed, 23 May 2007 14:54:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231403.24439.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
 <200705231403.24439.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:
> > You told it to not forward memory. Why complain when it does as told?
> 
> Well, because that's not actually very useful functionality, and likely 
> makes software that seems "obviously" correct wrt the PCI spec break.

I agree that a chip that doesn't do it isn't broken either, but the fact 
is, there is never any reason to disable MEM/IO on a host bridge. Doing so 
is senseless - it can never be a valid operation. So I duspute the 
"obviously correct" part. It's _not_ obviously correct at all.

To get back to the MMIO example: even if you were to never shut off RAM, 
if you turn off just PCI MMIO on the northbridge, what is a mmconfig cycle 
supposed to do? It's not going to _work_ if you disable MEM accesses.

So again, the only sane situation is: don't do it then! You claim that 
hardware shouldn't do it, but I don't think software is in any different 
situation at all! If it's insane to do, then software shouldn't do it.

It's just insane to turn off the MEM bit. There's simply no valid reason 
to. And any PCI spec that says you should is *broken*, or written by 
somebody who really only meant to talk about normal PCI devices, not 
bridges.

> Apparently Vista will move away from using type 1 config space accesses 
> though, so if we keep using it, we'll probably run into some lame board 
> that assumes you're using mmconfig at some point in the near future.  

How are those boards going to set up mmconfig? The whole standard is 
broken, since there is no way to set it up.

Trust the firmware? What a piece of crap!

		Linus
