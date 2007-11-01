Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbXKAOJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbXKAOJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXKAOJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:09:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39164 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbXKAOJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:09:24 -0400
Date: Thu, 1 Nov 2007 07:08:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Martin Mares <mj@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <20071101070855.1e8ef975@laptopd505.fenrus.org>
In-Reply-To: <mj+md-20071101.082743.5958.albireo@ucw.cz>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
	<200710251622.36773.jbarnes@virtuousgeek.org>
	<20071026025407.GA21408@kroah.com>
	<200710260959.46811.jbarnes@virtuousgeek.org>
	<20071027024140.GC29039@kroah.com>
	<47267232.3020506@shaw.ca>
	<alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
	<20071030094756.779ac5c0@laptopd505.fenrus.org>
	<alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
	<20071030102820.47a6e365@laptopd505.fenrus.org>
	<mj+md-20071101.082743.5958.albireo@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 09:31:40 +0100
Martin Mares <mj@ucw.cz> wrote:

> Hello!
> 
> > something like
> > int pci_enable_mmconfig(struct pci_dev *pdev) ?
> > sounds like a very solid plan to me...
> 
> Please remember that the driver is not the sole user of the PCI config
> space -- user-space programs (e.g., lspci) can access it via sysfs,
> too. Should we force users of such programs to add a magic kernel
> parameter to enable MMCONFIG? Does not make much sense.
> 
> Maybe we should do all bus scanning with conf1 and then try if
> MMCONFIG returns the same values?

that is already in the code today but not nearly enough; there's a ton
of cases where it's "touch mmconfig and the box is dead"...
