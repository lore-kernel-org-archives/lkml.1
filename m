Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXJ3Rco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXJ3Rco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJ3Rcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:32:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbXJ3Rce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:32:34 -0400
Date: Tue, 30 Oct 2007 10:28:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <20071030102820.47a6e365@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
	<200710251622.36773.jbarnes@virtuousgeek.org>
	<20071026025407.GA21408@kroah.com>
	<200710260959.46811.jbarnes@virtuousgeek.org>
	<20071027024140.GC29039@kroah.com>
	<47267232.3020506@shaw.ca>
	<alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
	<20071030094756.779ac5c0@laptopd505.fenrus.org>
	<alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:07:48 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > The fact is, CONF1 style accesses are just safer, and *work*. 
> > 
> > I would suggest a slight twist then: use CONF1 *until* you're using
> > something above 256, and then and only then switch to MMCONFIG from
> > then on for all accesses.
> 
> No.
> 
> Maybe if you do it per-device, and only *after* probing (ie we have
> seen multiple, and successful, accesses), but globally, absolutely
> not. That would be useless. The bugs we have had in this area have
> been exactly the kinds of things like "we don't know the real size of
> the MMCONFIG areas" etc.

sorry I wasn't very clear, I meant "per device".

> 
> I could easily see device driver writers probing to see if something 
> works, and I absolutely don't think we should just automatically
> enable MMCONFIG from then on.
> 
> But maybe we could have a per-device flag that a driver *can* set. Ie
> have the logic be:
> 
>  - use MMCONFIG if we have to (reg >= 256)
> 
> OR
> 
>  - use MMCONFIG if the driver specifically asked us to

something like
int pci_enable_mmconfig(struct pci_dev *pdev) ?
sounds like a very solid plan to me...


> Maybe somebody inside Intel could just clarify the documentation, and 
> change it from "you're not supposed to mix" to "mix all you want". 

I'll see what I can do ;)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
