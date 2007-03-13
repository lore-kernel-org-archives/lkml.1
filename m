Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbXCMVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbXCMVUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXCMVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:20:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623AbXCMVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:20:54 -0400
Date: Tue, 13 Mar 2007 14:20:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <20070313194204.5192ab19@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0703131418300.9690@woody.linux-foundation.org>
References: <1173735075.5936.139.camel@localhost.localdomain>
 <Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
 <20070313194204.5192ab19@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Mar 2007, Cornelia Huck wrote:
> 
> Another call that deadlocked with Oliver's patch is ungroup for s390
> ccwgroup devices. It can be made to work again with a similar patch.

Could we please make this easier to use by having some common sysfs helper 
routine for this kind of "delayed_store()" functionality.

I'm not a huge fan of delayed work at all, but if we have to have it, at 
least make it one generic function rather than having multiple functions 
all doing their own workqueue logic for it.

		Linus
