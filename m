Return-Path: <linux-kernel-owner+w=401wt.eu-S968122AbXEHOLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968122AbXEHOLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967658AbXEHOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:11:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41944 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967652AbXEHOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:11:49 -0400
Date: Tue, 8 May 2007 16:11:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070508141149.GJ4226@stusta.de>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:37:13PM +0200, Cornelia Huck wrote:
> As I wanted to add multithreaded probing for some s390 busses, I
> discovered that the commit above removed the multithreaded probing
> infrastructure again, while just some days before some of my patches
> reworking it had been merged... I thought
> http://marc.info/?l=linux-kernel&m=117591868412593&w=2 meant that we
> should go ahead with per-subsystem multithreaded probing?

My patch (that started the discussion you mentioned and seems to have 
been applied unchanged) contained both the wanted PCI_MULTITHREAD_PROBE 
removal and a removal of some of your new infrastructure.

Let's revert it, and I'll then send a new patch containing only the 
PCI_MULTITHREAD_PROBE removal.

> (OK, PCI_MULTITHREAD_PROBE should not depend on BROKEN, but on
> EXPERIMENTAL with the reworked probing infrastructure. This got mixed
> up, I can send a patch that changes it.)

You meant to say:
  depends on EXPERIMENTAL && !ATA && !IDE && !...

Multithreaded probing on the PCI bus currently breaks too much kernel 
code.

And we've already seen how many systems it therefore breaks in practice.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

