Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbXEHTcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbXEHTcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031567AbXEHTcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:32:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031582AbXEHTcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:32:04 -0400
Date: Tue, 8 May 2007 12:31:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Cornelia Huck wrote:
> 
> Is there any reason why a driver shouldn't be able to handle probing
> several devices at once?

Internal driver reasons?

Look, Cornelia, there's about a million drivers in the kernel. They are 
not all safe. End of discussion.

If you are willing to go through them all, fix everything, test it, talk 
with all maintainers, all the more power to you.

As it is, that's not going to happen. So you should *assume* that drivers 
are not expecting to be called multiple times in parallel. And if they 
are, you may then assume that people don't want them to be, because they 
want stable naming.

> What if two devices become hotplugged at the same time? Does this imply 
> that the bus _always_ needs to do some serializing there?

You want to test it? Be my guest.

But the final nail in the coffin is that doing it at the bus level is 
INFERIOR. As you yourself admitted, it's better to do some things 
synchronously.

		Linus
