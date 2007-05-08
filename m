Return-Path: <linux-kernel-owner+w=401wt.eu-S968080AbXEHPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968080AbXEHPcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967725AbXEHPYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:24:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966027AbXEHPPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:15:38 -0400
Date: Tue, 8 May 2007 08:15:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg K-H <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.0.98.0705080812160.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Cornelia Huck wrote:
>
> As I wanted to add multithreaded probing for some s390 busses, I
> discovered that the commit above removed the multithreaded probing
> infrastructure again, while just some days before some of my patches
> reworking it had been merged...

No.

I am *not* reverting that patch. The whole PCI bus-level multi-threaded 
stuff was an incredibly broken idea.

If you have problems with probing, it's not going to be about the host 
bus. It might be things like SCSI buses etc, and if somebody makes *those* 
be more threaded, I'm ok with it. But I'm not going to accept another 
broken PCI bus probe threading patch.

> (OK, PCI_MULTITHREAD_PROBE should not depend on BROKEN, but on
> EXPERIMENTAL with the reworked probing infrastructure. This got mixed
> up, I can send a patch that changes it.)

No. No. No. 

Probing the core bus was broken. Not "experimental". Broken. It not only 
threaded the wrogn area entirely, it also totally screwed up several 
driver subsystems (like IDE).

			Linus
