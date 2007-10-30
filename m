Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbXJ3PQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbXJ3PQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXJ3PPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:15:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbXJ3PPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:15:52 -0400
Date: Tue, 30 Oct 2007 08:15:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       akpm@linux-foundation.org, ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <47267232.3020506@shaw.ca>
Message-ID: <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com>
 <47267232.3020506@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Oct 2007, Robert Hancock wrote:
> 
> The other possible workaround would be to avoid using MMCONFIG until the BAR
> sizing is done. 

The only sane solution is the one that people constantly seem to ignore:

 - only use MMCONFIG if absolutely required by the access itself

In other words, make the MMCONFIG code fall back on old-style accesses for 
any register access to a word with reg+size <= 256.

At that point, almost all the issues with mmconfig just go away, BECAUSE 
NOBODY USES IT, so it doesn't matter if it's broken?

The fact is, CONF1 style accesses are just safer, and *work*. 

Can we please just do that? 

		Linus
