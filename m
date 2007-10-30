Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXJ3QwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXJ3QwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXJ3QwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:52:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39609 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbXJ3QwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:52:04 -0400
Date: Tue, 30 Oct 2007 09:47:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <20071030094756.779ac5c0@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
	<200710251622.36773.jbarnes@virtuousgeek.org>
	<20071026025407.GA21408@kroah.com>
	<200710260959.46811.jbarnes@virtuousgeek.org>
	<20071027024140.GC29039@kroah.com>
	<47267232.3020506@shaw.ca>
	<alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 08:15:46 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 29 Oct 2007, Robert Hancock wrote:
> > 
> > The other possible workaround would be to avoid using MMCONFIG
> > until the BAR sizing is done. 
> 
> The only sane solution is the one that people constantly seem to
> ignore:
> 
>  - only use MMCONFIG if absolutely required by the access itself
> 
> In other words, make the MMCONFIG code fall back on old-style
> accesses for any register access to a word with reg+size <= 256.

the problem is... you're not supposed to mix both types of accesses.
 
> At that point, almost all the issues with mmconfig just go away,
> BECAUSE NOBODY USES IT, so it doesn't matter if it's broken?
> 
> The fact is, CONF1 style accesses are just safer, and *work*. 

I would suggest a slight twist then: use CONF1 *until* you're using
something above 256, and then and only then switch to MMCONFIG from
then on for all accesses.

That should solve the spec issue (yes I know about specs, but this is
one of those things that will bite us in the future if we're not
careful)

