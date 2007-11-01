Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXKAJqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXKAJqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbXKAJqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:46:45 -0400
Received: from jabberwock.ucw.cz ([89.250.246.4]:59776 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXKAJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:46:44 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 05:46:44 EDT
Date: Thu, 1 Nov 2007 09:31:40 +0100
From: Martin Mares <mj@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <mj+md-20071101.082743.5958.albireo@ucw.cz>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com> <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com> <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org> <20071030094756.779ac5c0@laptopd505.fenrus.org> <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org> <20071030102820.47a6e365@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030102820.47a6e365@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> something like
> int pci_enable_mmconfig(struct pci_dev *pdev) ?
> sounds like a very solid plan to me...

Please remember that the driver is not the sole user of the PCI config
space -- user-space programs (e.g., lspci) can access it via sysfs, too.
Should we force users of such programs to add a magic kernel parameter
to enable MMCONFIG? Does not make much sense.

Maybe we should do all bus scanning with conf1 and then try if MMCONFIG
returns the same values?

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
"Beware of bugs in the above code; I have only proved it correct, not tried it." -- D.E.K.
