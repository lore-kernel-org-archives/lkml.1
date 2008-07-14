Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYGNAl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYGNAl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYGNAlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:41:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbYGNAlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:41:19 -0400
Date: Sun, 13 Jul 2008 17:41:19 -0700 (PDT)
Message-Id: <20080713.174119.71992292.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <487A61DD.6090304@firstfloor.org>
References: <487A083F.9010301@firstfloor.org>
	<20080713.124610.193703496.davem@davemloft.net>
	<487A61DD.6090304@firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sun, 13 Jul 2008 22:13:17 +0200

> David Miller wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > Date: Sun, 13 Jul 2008 15:50:55 +0200
> > 
> >> Still I would expect that modern IO controllers are typically fast
> >> enough at processing SG lists that it shouldn't matter much.
> > 
> > I know it matters a lot on sparc64 ESP scsi controllers.
> > 
> > You can only have one address/len pair DMA'ing at a time and you have
> > to service an interrupt to load in the the next DMA sg elements into
> > the chips registers.
> > 
> > Merging is essentially a must for performance on those cards.
> 
> Well right now your setup breaks all controllers with "weird requirements"
> like 64k DMA or similar. You'll need to find some way to turn off BIO
> merge for those at least.
> 
> Perhaps this needs to be really a block queue attribute instead of a global?

Like I said, that code was written at a time when none of the block
segment check stuff existed, and therefore worked perfectly fine in
the environment in which it was created.

Someone added the segmenting code, but didn't bother to add proper
checking to the merging bits.

Usually we revert code that breaks things like that, right?

So I find it unusual for people to talk about turning off the
code that was working perfectly fine previously in situations
like this.

