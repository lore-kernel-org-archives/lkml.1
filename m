Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXGVEDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXGVEDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 00:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXGVEDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 00:03:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36492 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXGVEDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 00:03:12 -0400
Message-ID: <46A2D6F7.9080309@garzik.org>
Date: Sun, 22 Jul 2007 00:03:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org>	 <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>	 <469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain>	 <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>	 <m3644e2abd.fsf@maximus.localdomain> <1184977973.5439.45.camel@localhost.localdomain>
In-Reply-To: <1184977973.5439.45.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Thus, we have two choices here:
> 
>  - The simple one: sysfs_create_blah() displays a warning when it fails
> and has no must_check
> 
>  - The one that adds code everywhere (the current one):
> sysfs_create_blah() returns an error, has much_check, and thus all
> callers like I described abvoe need to add code to test it and print a
> warning. Lots of added .text and .data for little benefit.


Not necessarily as simple as that -- you need to make sure you don't 
pass something bogus to a sysfs_remove_blah() function at 
unregister/unload time, if sysfs_create_blah() failed.

Certainly sysfs_foo() failure is often ignorable in the sense that you 
want the driver to keep loading... but that does not imply that it is 
strictly ignorable, if you also consider the associated cleanup code.

	Jeff


