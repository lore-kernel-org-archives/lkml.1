Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbXGVVaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbXGVVaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXGVV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:29:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:33294 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXGVV3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:29:52 -0400
Subject: Re: [git patches] two warning fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <46A2D6F7.9080309@garzik.org>
References: <20070718235504.GA9601@havoc.gtf.org>
	 <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
	 <469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain>
	 <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
	 <m3644e2abd.fsf@maximus.localdomain>
	 <1184977973.5439.45.camel@localhost.localdomain>
	 <46A2D6F7.9080309@garzik.org>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 07:29:20 +1000
Message-Id: <1185139760.5439.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Not necessarily as simple as that -- you need to make sure you don't 
> pass something bogus to a sysfs_remove_blah() function at 
> unregister/unload time, if sysfs_create_blah() failed.
> 
> Certainly sysfs_foo() failure is often ignorable in the sense that you 
> want the driver to keep loading... but that does not imply that it is 
> strictly ignorable, if you also consider the associated cleanup code.

It should be trivial enough to have sysfs_create_blah() do enough
initializations before it can fail so that sysfs_remove_blah() do the
right thing regardless.

It's actually a major PITA for a driver that creates a whole bunch of
sysfs files to have to track precisely which ones were created
successfully for the error path. If it's a single function, goto does
the trick but if for some reason it's not, it's really annoying.

Ben.


