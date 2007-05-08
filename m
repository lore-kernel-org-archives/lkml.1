Return-Path: <linux-kernel-owner+w=401wt.eu-S966435AbXEHPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966435AbXEHPpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968067AbXEHPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:32:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965880AbXEHP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:27:48 -0400
Date: Tue, 8 May 2007 08:27:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070508141149.GJ4226@stusta.de>
Message-ID: <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Adrian Bunk wrote:
> 
> Let's revert it, and I'll then send a new patch containing only the 
> PCI_MULTITHREAD_PROBE removal.

I really don't want to revert that removal. If somebody wants to resurrect 
a part of the patch that has nothing to do with PCI, in order to do it for 
some other bus, just send that as a patch (not as a revert). But no, I'm 
not going to revert that patch.

And no, we should not do it at the device core level. In fact, I don't 
think we should do it at that level at all. 

I'm pretty sure that the performance problems are at individual device 
drivers, and that the right solution is to thread at *that* level. Not 
higher up.

Threading at the bus level just inevitably means things like random 
numbers for devices depending on some timing/scheduling issue. That's 
nasty.

Threading at a driver level still does that (ie individual disks may be 
attached in some order that depends on how fast they are to respond), but 
in a much more controlled fashion, and only for drivers that explicitly 
say that they can do it.

		Linus
