Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXD1KLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXD1KLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXD1KLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:11:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43417 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756150AbXD1KLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:11:39 -0400
Date: Sat, 28 Apr 2007 11:15:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428111504.24641d03@the-village.bc.nu>
In-Reply-To: <20070428030213.4787031f.akpm@linux-foundation.org>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<p73tzv022qw.fsf@bingen.suse.de>
	<20070428030213.4787031f.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The warning is bogus imho. How do you write recovery code for internal
> > broken code logic? 
> 
> Yes, it is marginal.  But people do very often reach for BUG_ON() where
> they could have at least partly recovered in some fashion - enough for the
> info to hit the logs so we have a better chance of fixing it.

At least one way to handle BUG_ON() type situations more cleanly (for
some anyway) is to fake a hot-unplug/plug event. Thats something that
would be nice to get into the PCI code as it'll let you recover from many
things (even in some cases hardware fails if you go via D3). Does need
some supporting logic (eg for networking to get back with the same config
and online)
